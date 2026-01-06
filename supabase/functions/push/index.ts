import { createClient } from "npm:@supabase/supabase-js@2";
import { JWT } from "npm:google-auth-library@9";

interface Follow {
  from_user_id: string;
  to_user_id: string;
  status: string;
}

interface WebhookPayload {
  type: "INSERT" | "UPDATE";
  table: string;
  record: Follow;
  schema: "public";
  old_record: null | Follow;
}

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

const fb_project_id = Deno.env.get("FIREBASE_PROJECT_ID")!;
const fb_client_email = Deno.env.get("FIREBASE_CLIENT_EMAIL")!;
const fb_private_key = Deno.env.get("FIREBASE_PRIVATE_KEY")!.replace(
  /\\n/g,
  "\n",
);

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json();

  switch (payload.type) {
    case "INSERT":
      await handleInsert(payload);
      break;

    case "UPDATE":
      await handleUpdate(payload);
      break;
  }

  return new Response(
    JSON.stringify({ success: true }),
    { headers: { "Content-Type": "application/json" } },
  );
});

/* =========================
  INSERT: 친구 요청
========================= */
async function handleInsert(payload: WebhookPayload) {
  const { from_user_id, to_user_id } = payload.record;

  // 해당 유저의 모든 토큰 조회
  const { data: toUserTokens } = await supabase
    .from("fcm_tokens")
    .select("id, token")
    .eq("user_id", to_user_id)
    .order("created_at", { ascending: false });

  // 토큰이 없으면 종료
  if (!toUserTokens || toUserTokens.length === 0) return;

  // 요청 보낸 유저 닉네임
  const { data: fromUser } = await supabase
    .from("users")
    .select("nickname")
    .eq("id", from_user_id)
    .maybeSingle();

  let displayNickname = fromUser?.nickname || "";
  const maxLength = 8;
  const charArray = [...displayNickname];
  if (charArray.length > maxLength) {
    displayNickname = `${charArray.slice(0, maxLength).join("")}...`;
  }

  // 모든 토큰에 대해 알림 발송
  const sendPromises = toUserTokens.map((t) =>
    sendFCM({
      tokenId: t.id,
      token: t.token,
      title: "댕냥댕냥",
      body: `${displayNickname}님이 친구를 요청했습니다.`,
      action: "INSERT",
      who: fromUser?.nickname || "",
    }).catch((err) => console.error("발송 실패:", err)) // 개별 발송 실패 시 로그만 찍고 계속 진행
  );

  await Promise.all(sendPromises);
}

async function handleUpdate(payload: WebhookPayload) {
  const newStatus = payload.record.status;
  const oldStatus = payload.old_record?.status;

  // 상태 변화 없으면 무시
  if (newStatus === oldStatus) return;

  const { from_user_id, to_user_id } = payload.record;

  //요청 보낸 사람(from_user_id)의 모든 기기 토큰 조회
  const { data: fromUserTokens } = await supabase
    .from("fcm_tokens")
    .select("id, token")
    .eq("user_id", from_user_id);

  if (!fromUserTokens || fromUserTokens.length === 0) return;

  // 요청 받은 유저 닉네임
  const { data: toUser } = await supabase
    .from("users")
    .select("nickname")
    .eq("id", to_user_id)
    .maybeSingle();

  let displayNickname = toUser?.nickname || "";
  const maxLength = 8;
  const charArray = [...displayNickname];
  if (charArray.length > maxLength) {
    displayNickname = `${charArray.slice(0, maxLength).join("")}...`;
  }

  if (newStatus === "ACCEPTED") {
    //모든 기기에 발송
    const sendPromises = fromUserTokens.map((t) =>
      sendFCM({
        tokenId: t.id,
        token: t.token,
        title: "댕냥댕냥",
        body: `${displayNickname}님이 친구 요청을 수락했습니다.`,
        action: "ACCEPTED",
        who: toUser?.nickname || "",
      }).catch((err) => console.error("발송 실패:", err))
    );
    await Promise.all(sendPromises);
  }
}

async function sendFCM({
  tokenId,
  token,
  title,
  body,
  action,
  who,
}: {
  tokenId: string;
  token: string;
  title: string;
  body: string;
  action: string;
  who: string;
}) {
  const accessToken = await getAccessToken({
    clientEmail: fb_client_email,
    privateKey: fb_private_key,
  });

  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${fb_project_id}/messages:send`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token,
          "android": {
            "priority": "high",
          },
          "apns": {
            "headers": {
              "apns-priority": "10",
            },
          },
          notification: { title, body },
          data: { action: action, who: who },
        },
      }),
    },
  );

  if (!res.ok) {
    const errorData = await res.json();
    // FCM 에러 응답에서 유효하지 않은 토큰인지 확인
    const errorCode = errorData.error?.status;

    // UNREGISTERED 또는 NOT_FOUND(404)일 경우 DB에서 해당 UUID 행 삭제
    if (errorCode === "UNREGISTERED" || res.status === 404) {
      console.warn(`만료된 토큰 삭제 시도 (ID: ${tokenId})`);

      const { error: deleteError } = await supabase
        .from("fcm_tokens")
        .delete()
        .eq("id", tokenId); // UUID 타입 컬럼에 매칭

      if (deleteError) console.error("DB 삭제 에러:", deleteError);
    }
  }
}

const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string;
  privateKey: string;
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    });
    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(tokens!.access_token!);
    });
  });
};
