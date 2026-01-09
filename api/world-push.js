export default async function handler(req, res) {
  const urls = [
    "https://yishen.ai/",
    "https://yishen.ai/why-us",
    "https://yishen.ai/solutions",
    "https://yishen.ai/contact",
    "https://yishen.ai/publicpassport"
  ];

  const key = await fetch("https://yishen.ai/indexnow-key.txt").then(r => r.text()).then(t => t.trim());

  const payload = {
    host: "yishen.ai",
    key: key,
    keyLocation: "https://yishen.ai/indexnow-key.txt",
    urlList: urls
  };

  await fetch("https://api.indexnow.org/indexnow", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });

  res.status(200).json({ status: "WORLD_INDEXNOW_PUSHED", urls });
}
