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

  // 알림 받을 유저 토큰
  const { data: toUserToken } = await supabase
    .from("fcm_tokens")
    .select("token")
    .eq("user_id", to_user_id)
    .order("created_at", { ascending: false })
    .maybeSingle();

  if (!toUserToken?.token) return;

  // 요청 보낸 유저 닉네임
  const { data: fromUser } = await supabase
    .from("users")
    .select("nickname")
    .eq("id", from_user_id)
    .maybeSingle();

  await sendFCM({
    token: toUserToken.token,
    title: "PENDING",
    body: `${fromUser?.nickname}`,
  });
}

async function handleUpdate(payload: WebhookPayload) {
  const newStatus = payload.record.status;
  const oldStatus = payload.old_record?.status;

  // 상태 변화 없으면 무시
  if (newStatus === oldStatus) return;

  const { from_user_id, to_user_id } = payload.record;

  // 요청 보낸 사람에게 알림
  const { data: fromUserToken } = await supabase
    .from("fcm_tokens")
    .select("token")
    .eq("user_id", from_user_id)
    .order("created_at", { ascending: false })
    .maybeSingle();

  if (!fromUserToken?.token) return;

  // 요청 받은 유저 닉네임
  const { data: toUser } = await supabase
    .from("users")
    .select("nickname")
    .eq("id", to_user_id)
    .maybeSingle();

  if (newStatus === "ACCEPTED") {
    await sendFCM({
      token: fromUserToken.token,
      title: "ACCEPTED",
      body: `${toUser?.nickname}`,
    });
  }
}

async function sendFCM({
  token,
  title,
  body,
}: {
  token: string;
  title: string;
  body: string;
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
        },
      }),
    },
  );

  if (!res.ok) {
    throw await res.json();
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
