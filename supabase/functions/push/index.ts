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

  //일단 INSERT만 했을 경우

  //친구 요청 받을 유저의 토큰
  const { data: data_to_user } = await supabase.from("fcm_tokens")
    .select("token")
    .eq("user_id", payload.record.to_user_id)
    .single();

  //친구요청 보낸 유저의 닉네임
  const { data: data_from_user } = await supabase.from("users").select(
    "nickname",
  ).eq(
    "id",
    payload.record.from_user_id,
  ).single();

  const fcmToken = data_to_user?.token as string;

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
          token: fcmToken,
          notification: {
            title: "친구 요청",
            body: `${data_from_user?.nickname}님이 친구 요청을 보냈습니다.`,
          },
        },
      }),
    },
  );

  const resData = await res.json();
  if (res.status < 200 || 299 < res.status) {
    throw resData;
  }

  return new Response(JSON.stringify(resData), {
    headers: { "Content-Type": "application/json" },
  });
});

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
