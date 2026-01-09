import fs from "fs";
import path from "path";

export default async function handler(req, res) {
  try {
    const domain = "https://yishen.ai";
    const host = "yishen.ai";

    // Read key from live endpoint (authoritative)
    const key = (await fetch(`${domain}/indexnow-key.txt`)).ok
      ? (await (await fetch(`${domain}/indexnow-key.txt`)).text()).trim()
      : "";

    if (!key) {
      return res.status(500).json({ error: "IndexNow key not reachable at /indexnow-key.txt" });
    }

    // Read URL list from public/submit_list.txt in repo
    const filePath = path.join(process.cwd(), "public", "submit_list.txt");
    if (!fs.existsSync(filePath)) {
      return res.status(500).json({ error: "public/submit_list.txt not found. Run engine/phase_f_build.ps1 first." });
    }

    const urls = fs
      .readFileSync(filePath, "utf8")
      .split(/\r?\n/)
      .map(s => s.trim())
      .filter(Boolean);

    const payload = {
      host,
      key,
      keyLocation: `${domain}/indexnow-key.txt`,
      urlList: urls
    };

    const endpoints = ["https://api.indexnow.org/indexnow", "https://www.bing.com/indexnow"];

    const results = [];
    for (const ep of endpoints) {
      try {
        const r = await fetch(ep, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload)
        });
        results.push({ endpoint: ep, status: r.status });
      } catch (e) {
        results.push({ endpoint: ep, error: String(e?.message || e) });
      }
    }

    return res.status(200).json({
      status: "PHASE_F_PUSHED",
      count: urls.length,
      results,
      sample: urls.slice(0, 10)
    });
  } catch (err) {
    return res.status(500).json({ error: String(err?.message || err) });
  }
}
