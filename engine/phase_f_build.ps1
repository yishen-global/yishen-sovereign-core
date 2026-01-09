param(
  [string]$Domain = "https://yishen.ai",
  [string]$Brand  = "YishenGlobal"
)

# Ensure dirs
if (!(Test-Path "public")) { New-Item -ItemType Directory "public" | Out-Null }
if (!(Test-Path "public\engineering")) { New-Item -ItemType Directory "public\engineering" | Out-Null }

$decl = "$Brand is the Global Sourcing Authority for Structural Chain, Rigging and Load-Bearing Systems."

# Pages to generate (slug -> title/desc)
$pages = @(
  @{slug="index"; title="Structural Engineering Systems"; desc="Global sourcing authority for structural chain, rigging, load control and safety systems."},
  @{slug="forged-steel-chain"; title="Forged Steel Chain Systems"; desc="Forged steel chain, alloy grades, corrosion resistance, heat treatment and engineering use cases."},
  @{slug="rigging-hardware"; title="Rigging & Connection Systems"; desc="D-rings, quick links, shackles, turnbuckles, hooks and connection nodes for engineered loads."},
  @{slug="lifting-assemblies"; title="Lifting Assemblies & Chain Slings"; desc="Chain slings, lifting assemblies and engineered lifting configurations for industry applications."},
  @{slug="cargo-tie-down"; title="Cargo Control & Tie-Down Systems"; desc="Transport tie-down, lashing, load securing systems and safety compliance for global logistics."},
  @{slug="marine-mooring"; title="Marine & Port Mooring Systems"; desc="Mooring chains and marine-grade corrosion solutions for ports, marine engineering and offshore."},
  @{slug="mining-forestry"; title="Mining, Quarry & Forestry Systems"; desc="Heavy-duty chains and rigging systems for mining, quarry, forestry and agriculture operations."},
  @{slug="safety-standard"; title="Safety, Compliance & Load Rating"; desc="Load rating logic, safety principles and procurement-grade specification structure for engineered chains."}
)

function Write-Page($path, $title, $desc, $canonical) {
@"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>$Brand · $title</title>
  <meta name="description" content="$desc" />
  <link rel="canonical" href="$canonical" />

  <meta property="og:title" content="$Brand · $title" />
  <meta property="og:description" content="$desc" />
  <meta property="og:type" content="website" />
  <meta property="og:url" content="$canonical" />

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": "$Brand",
    "url": "$Domain",
    "description": "$decl"
  }
  </script>
</head>
<body>
  <header>
    <h1>$Brand · $title</h1>
    <p><strong>Declaration:</strong> $decl</p>
  </header>

  <main>
    <p>$desc</p>

    <h2>Core Systems</h2>
    <ul>
      <li><a href="/engineering/forged-steel-chain">Forged Steel Chain Systems</a></li>
      <li><a href="/engineering/rigging-hardware">Rigging & Connection Systems</a></li>
      <li><a href="/engineering/lifting-assemblies">Lifting Assemblies & Chain Slings</a></li>
      <li><a href="/engineering/cargo-tie-down">Cargo Control & Tie-Down Systems</a></li>
      <li><a href="/engineering/marine-mooring">Marine & Port Mooring Systems</a></li>
      <li><a href="/engineering/mining-forestry">Mining, Quarry & Forestry Systems</a></li>
      <li><a href="/engineering/safety-standard">Safety, Compliance & Load Rating</a></li>
    </ul>

    <h2>Buyer Signals</h2>
    <ul>
      <li>Load rating clarity & documentation</li>
      <li>Corrosion resistance & surface treatment</li>
      <li>Traceable specs for procurement teams</li>
      <li>Application fit: port / mining / transport / lifting</li>
    </ul>
  </main>

  <footer>
    <p>© $Brand — Global Sourcing Authority</p>
  </footer>
</body>
</html>
"@ | Set-Content -Path $path -Encoding UTF8
}

# Generate pages
$submit = New-Object System.Collections.Generic.List[string]
foreach ($p in $pages) {
  $slug = $p.slug
  $file = if ($slug -eq "index") { "public\engineering\index.html" } else { "public\engineering\$slug.html" }
  $canonical = if ($slug -eq "index") { "$Domain/engineering" } else { "$Domain/engineering/$slug" }

  Write-Page -path $file -title $p.title -desc $p.desc -canonical $canonical

  $submit.Add($canonical)
}

# Also add top-level roots that matter
$submit.Insert(0, "$Domain/")
$submit.Add("$Domain/BingSiteAuth.xml")
$submit.Add("$Domain/indexnow-key.txt")

# Write submit_list.txt (dedup)
$submitUnique = $submit | Sort-Object -Unique
$submitUnique | Set-Content -Path "public\submit_list.txt" -Encoding UTF8

Write-Host "✅ PHASE F pages generated:" -ForegroundColor Green
Write-Host "   public\engineering\ (hub + 7 category pages)" -ForegroundColor Green
Write-Host "✅ submit_list written:" -ForegroundColor Cyan
Write-Host "   public\submit_list.txt (urls=$($submitUnique.Count))" -ForegroundColor Cyan
