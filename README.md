<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="apple-mobile-web-app-title" content="JW Reports">
<meta name="theme-color" content="#1a2744">
<title>JW Reports · Jamie Watson</title>
<link rel="apple-touch-icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 180 180'%3E%3Crect width='180' height='180' rx='40' fill='%231a2744'/%3E%3Ctext x='90' y='115' font-family='Georgia,serif' font-size='80' font-weight='bold' fill='%23e8a020' text-anchor='middle'%3EJW%3C/text%3E%3C/svg%3E">
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
<style>
  :root {
    --navy:#1a2744; --navy-mid:#2a3f6f; --navy-light:#3d5a9e;
    --amber:#e8a020; --amber-light:#fef3dc;
    --red:#c0392b; --red-light:#fdecea;
    --green:#1a7a3c; --green-light:#e8f5ed;
    --grey-bg:#f4f6fa; --grey-border:#dde2ed;
    --white:#ffffff; --text:#1a2744; --text-muted:#6b7a99;
    --radius:10px; --shadow:0 2px 16px rgba(26,39,68,0.10);
  }
  *{box-sizing:border-box;margin:0;padding:0;}
  body{font-family:'Georgia',serif;background:var(--grey-bg);color:var(--text);min-height:100vh;padding-bottom:40px;}
  .app-header{background:var(--navy);color:white;padding:18px 20px 14px;display:flex;align-items:flex-end;gap:12px;position:sticky;top:0;z-index:100;box-shadow:0 2px 12px rgba(0,0,0,0.18);}
  .app-header-logo{font-size:22px;font-weight:bold;letter-spacing:-0.5px;line-height:1;}
  .app-header-logo span{color:var(--amber);}
  .app-header-sub{font-size:11px;color:rgba(255,255,255,0.55);font-family:'Courier New',monospace;letter-spacing:0.5px;margin-bottom:1px;}
  .header-actions{margin-left:auto;display:flex;gap:8px;align-items:center;}
  .saved-indicator{font-size:10px;color:rgba(255,255,255,0.45);font-family:'Courier New',monospace;}
  .btn-header{background:rgba(255,255,255,0.12);border:1px solid rgba(255,255,255,0.2);color:white;font-size:12px;padding:6px 12px;border-radius:6px;cursor:pointer;font-family:inherit;transition:background 0.15s;}
  .btn-header:hover{background:rgba(255,255,255,0.22);}
  .container{max-width:700px;margin:0 auto;padding:20px 16px;}
  .card{background:var(--white);border-radius:var(--radius);box-shadow:var(--shadow);margin-bottom:16px;overflow:hidden;}
  .card-header{background:var(--navy);color:white;padding:12px 18px;font-size:13px;font-weight:bold;letter-spacing:0.8px;text-transform:uppercase;}
  .card-body{padding:18px;}
  .dropdowns{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
  .field-group{display:flex;flex-direction:column;gap:5px;}
  .field-group label{font-size:11px;text-transform:uppercase;letter-spacing:0.7px;color:var(--text-muted);font-family:'Courier New',monospace;}
  select,input[type="text"],input[type="number"],textarea{width:100%;border:1.5px solid var(--grey-border);border-radius:7px;padding:10px 12px;font-size:15px;font-family:inherit;color:var(--text);background:var(--white);appearance:none;transition:border-color 0.15s,box-shadow 0.15s;outline:none;}
  select:focus,input:focus,textarea:focus{border-color:var(--navy-light);box-shadow:0 0 0 3px rgba(61,90,158,0.12);}
  select{background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath fill='%236b7a99' d='M6 8L0 0h12z'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 12px center;padding-right:32px;}
  #notesInput{font-family:'Courier New',monospace;font-size:14px;line-height:1.7;min-height:220px;resize:vertical;background:#fafbfd;}
  .notes-hint{font-size:12px;color:var(--text-muted);margin-top:8px;font-family:'Courier New',monospace;}
  .btn-parse{width:100%;background:var(--navy);color:white;border:none;border-radius:var(--radius);padding:16px;font-size:16px;font-family:inherit;font-weight:bold;letter-spacing:0.5px;cursor:pointer;transition:background 0.15s,transform 0.1s;margin-bottom:16px;}
  .btn-parse:hover{background:var(--navy-mid);}
  .btn-parse:active{transform:scale(0.98);}
  #previewSection{display:none;}
  .preview-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;}
  .preview-field{display:flex;flex-direction:column;gap:4px;}
  .preview-field.full-width{grid-column:1/-1;}
  .preview-field label{font-size:11px;text-transform:uppercase;letter-spacing:0.7px;color:var(--text-muted);font-family:'Courier New',monospace;}
  .preview-field input,.preview-field select,.preview-field textarea{font-size:14px;padding:8px 10px;}
  .flag-banner{background:var(--amber-light);border:1.5px solid var(--amber);border-radius:8px;padding:12px 14px;margin-bottom:10px;font-size:13px;color:#7a4a00;}
  .flag-banner strong{display:block;margin-bottom:4px;font-size:13px;}
  .flag-actions{display:flex;gap:8px;margin-top:8px;flex-wrap:wrap;}
  .btn-flag{background:var(--amber);color:white;border:none;border-radius:6px;padding:6px 12px;font-size:12px;font-family:inherit;cursor:pointer;font-weight:bold;}
  .btn-flag-ok{background:var(--green);}
  .wheel-table{width:100%;border-collapse:collapse;font-size:13px;}
  .wheel-table th{background:var(--navy-mid);color:white;padding:7px 8px;text-align:center;font-size:11px;letter-spacing:0.5px;}
  .wheel-table td{padding:7px 8px;border-bottom:1px solid var(--grey-border);text-align:center;}
  .wheel-table tr:nth-child(even) td{background:var(--grey-bg);}
  .wheel-table input[type="text"],.wheel-table input[type="number"]{padding:5px 7px;font-size:13px;text-align:center;width:70px;}
  .btn-remove{background:none;border:none;color:var(--red);font-size:18px;cursor:pointer;line-height:1;padding:0;}
  .btn-add-part{background:none;border:1.5px dashed var(--navy-light);color:var(--navy-light);border-radius:6px;padding:7px 12px;font-size:12px;cursor:pointer;font-family:inherit;width:100%;text-align:left;margin-top:4px;}
  .labour-row{display:grid;grid-template-columns:3fr 80px 30px;gap:8px;margin-bottom:8px;align-items:center;}
  .btn-add-labour{background:none;border:1.5px dashed var(--green);color:var(--green);border-radius:6px;padding:7px 12px;font-size:12px;cursor:pointer;font-family:inherit;width:100%;text-align:left;margin-top:4px;}
  .finding-row{display:grid;grid-template-columns:2fr 120px 2fr 30px;gap:8px;margin-bottom:8px;align-items:center;}
  .btn-add-finding{background:none;border:1.5px dashed var(--red);color:var(--red);border-radius:6px;padding:7px 12px;font-size:12px;cursor:pointer;font-family:inherit;width:100%;text-align:left;margin-top:4px;}
  .btn-generate{width:100%;background:var(--green);color:white;border:none;border-radius:var(--radius);padding:18px;font-size:18px;font-family:inherit;font-weight:bold;cursor:pointer;transition:background 0.15s,transform 0.1s;margin-top:8px;letter-spacing:0.5px;}
  .btn-generate:hover{background:#155f2e;}
  .btn-generate:active{transform:scale(0.98);}
  .additional-note-row{display:grid;grid-template-columns:24px 80px 3fr 30px;gap:8px;margin-bottom:8px;align-items:center;}
  .note-num{font-weight:bold;color:var(--text-muted);font-size:14px;text-align:center;}
  .toast{position:fixed;bottom:24px;left:50%;transform:translateX(-50%) translateY(80px);background:var(--navy);color:white;padding:12px 24px;border-radius:24px;font-size:14px;font-weight:bold;z-index:999;transition:transform 0.3s ease;pointer-events:none;}
  .toast.show{transform:translateX(-50%) translateY(0);}
  .collapsible-header{cursor:pointer;user-select:none;display:flex;justify-content:space-between;align-items:center;}
  .collapsible-header:hover{background:#243660;}
  textarea.notes-multi{min-height:60px;font-family:inherit;font-size:13px;resize:vertical;}
  .btn-hamburger{background:rgba(255,255,255,0.12);border:1px solid rgba(255,255,255,0.2);border-radius:8px;width:40px;height:36px;display:flex;flex-direction:column;justify-content:center;align-items:center;gap:5px;cursor:pointer;padding:0;flex-shrink:0;}
  .btn-hamburger span{display:block;width:18px;height:2px;background:white;border-radius:2px;transition:all 0.2s;}
  .btn-hamburger:hover{background:rgba(255,255,255,0.22);}
  .menu-item{display:block;width:100%;background:none;border:none;padding:13px 18px;text-align:left;font-size:14px;font-family:inherit;color:#1a2744;cursor:pointer;transition:background 0.1s;}
  .menu-item:hover{background:#f4f6fa;}
  /* PARSE SUMMARY BOXES */
  .parse-summary{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:16px;}
  .parse-box{border-radius:var(--radius);padding:14px;font-size:12px;font-family:'Courier New',monospace;line-height:1.7;}
  .parse-box-captured{background:var(--green-light);border:1.5px solid var(--green);}
  .parse-box-missed{background:var(--red-light);border:1.5px solid var(--red);}
  .parse-box h4{font-size:11px;font-weight:bold;letter-spacing:0.7px;text-transform:uppercase;margin-bottom:8px;}
  .parse-box-captured h4{color:var(--green);}
  .parse-box-missed h4{color:var(--red);}
  .parse-box p{color:var(--text);white-space:pre-wrap;word-break:break-word;}
  .parse-box-missed p{color:#7a0000;}
  /* RESTORED BANNER */
  .restored-banner{background:var(--amber-light);border:2px solid var(--amber);border-radius:8px;padding:12px 16px;margin-bottom:12px;font-size:13px;color:#7a4a00;display:flex;justify-content:space-between;align-items:center;}
  .restored-banner strong{display:block;font-size:13px;}
  /* HISTORY */
  .history-search-bar{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-bottom:12px;}
  .history-search-bar input,.history-search-bar select{font-size:13px;padding:8px 10px;}
  .history-summary{background:var(--grey-bg);border-radius:8px;padding:10px 14px;margin-bottom:12px;display:flex;justify-content:space-between;flex-wrap:wrap;gap:6px;}
  .history-summary span{font-size:12px;color:var(--text-muted);}
  .history-summary strong{color:var(--green);}
  .job-card{padding:12px 0;border-bottom:1px solid #eee;}
  .job-card-top{display:flex;justify-content:space-between;align-items:flex-start;}
  .job-card-actions{display:flex;gap:6px;margin-top:8px;}
  .btn-view-job{background:var(--navy);color:white;border:none;border-radius:6px;padding:6px 14px;font-size:12px;cursor:pointer;font-family:inherit;font-weight:bold;}
  .btn-del-job{background:none;border:1px solid var(--red);color:var(--red);border-radius:6px;padding:6px 10px;font-size:12px;cursor:pointer;font-family:inherit;}
  @media(max-width:480px){
    .dropdowns{grid-template-columns:1fr;}
    .preview-grid{grid-template-columns:1fr;}
    .preview-field.full-width{grid-column:1;}
    .finding-row{grid-template-columns:1fr 100px 30px;grid-template-rows:auto auto;}
    .finding-row .finding-notes{grid-column:1/-1;}
    .labour-row{grid-template-columns:2fr 70px 30px;}
    .wheel-table{font-size:11px;}
    .wheel-table input{width:52px;font-size:11px;}
    .history-search-bar{grid-template-columns:1fr;}
    .parse-summary{grid-template-columns:1fr;}
  }
</style>
</head>
<body>

<header class="app-header">
  <div>
    <div class="app-header-logo">JW <span>Reports</span></div>
    <div class="app-header-sub">JAMIE WATSON · MECHANIC</div>
  </div>
  <div class="header-actions">
    <span class="saved-indicator" id="savedIndicator"></span>
    <button class="btn-hamburger" onclick="toggleMenu()" id="menuBtn" aria-label="Menu">
      <span></span><span></span><span></span>
    </button>
  </div>
</header>

<!-- DROPDOWN MENU -->
<div id="dropdownMenu" style="display:none;position:fixed;top:62px;right:12px;background:white;border-radius:10px;box-shadow:0 4px 24px rgba(0,0,0,0.18);z-index:150;min-width:180px;overflow:hidden;">
  <button class="menu-item" onclick="loadSaved();toggleMenu()">↩ Resume Draft</button>
  <button class="menu-item" onclick="showHistory();toggleMenu()">📋 Job History</button>
  <button class="menu-item" onclick="showCustomers();toggleMenu()">👤 Saved Customers</button>
  <div style="height:1px;background:#eee;margin:2px 0;"></div>
  <button class="menu-item" onclick="exportBackup();toggleMenu()">⬇ Export Backup</button>
  <button class="menu-item" onclick="document.getElementById('importFile').click();toggleMenu()">⬆ Restore Backup</button>
  <div style="height:1px;background:#eee;margin:2px 0;"></div>
  <button class="menu-item" style="color:#c0392b;" onclick="clearAll();toggleMenu()">✕ Clear All</button>
</div>
<input type="file" id="importFile" accept=".json" style="display:none;" onchange="importBackup(event)">

<!-- HISTORY MODAL -->
<div id="historyModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.55);z-index:200;padding:20px;overflow-y:auto;">
  <div style="background:white;border-radius:12px;max-width:640px;margin:0 auto;overflow:hidden;box-shadow:0 8px 40px rgba(0,0,0,0.3);">
    <div style="background:#1a2744;color:white;padding:14px 18px;display:flex;justify-content:space-between;align-items:center;">
      <span style="font-weight:bold;font-size:15px;">📋 Job History</span>
      <button onclick="closeHistory()" style="background:none;border:none;color:white;font-size:24px;cursor:pointer;line-height:1;">×</button>
    </div>
    <div style="padding:16px;">
      <div class="history-search-bar">
        <input type="text" id="historySearch" placeholder="Search rego, customer, vehicle..." oninput="renderHistory()">
        <select id="historyFilterType" onchange="renderHistory()">
          <option value="">All Job Types</option>
          <option value="full">Full Inspection</option>
          <option value="service">Service + Inspection</option>
          <option value="safety">Safety Check</option>
          <option value="repair">Repair Only</option>
          <option value="inspection_repair">Inspection + Repair</option>
          <option value="service_repair">Service + Repair</option>
          <option value="safety_repair">Safety Check + Repair</option>
        </select>
        <select id="historyFilterCust" onchange="renderHistory()">
          <option value="">All Customers</option>
          <option value="carguysinspection">The Car Guys</option>
          <option value="private">Private</option>
          <option value="cash">Cash</option>
        </select>
        <select id="historyFilterQ" onchange="renderHistory()">
          <option value="">All Quarters</option>
          <option value="1">Q1 Jan–Mar</option>
          <option value="2">Q2 Apr–Jun</option>
          <option value="3">Q3 Jul–Sep</option>
          <option value="4">Q4 Oct–Dec</option>
        </select>
      </div>
      <div class="history-summary" id="historySummary"></div>
    </div>
    <div id="historyList" style="padding:0 16px 16px;max-height:60vh;overflow-y:auto;"></div>
  </div>
</div>

<!-- CUSTOMERS MODAL -->
<div id="customersModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.55);z-index:200;padding:20px;overflow-y:auto;">
  <div style="background:white;border-radius:12px;max-width:500px;margin:0 auto;overflow:hidden;box-shadow:0 8px 40px rgba(0,0,0,0.3);">
    <div style="background:#1a2744;color:white;padding:14px 18px;display:flex;justify-content:space-between;align-items:center;">
      <span style="font-weight:bold;font-size:15px;">👤 Saved Customers</span>
      <button onclick="closeCustomers()" style="background:none;border:none;color:white;font-size:24px;cursor:pointer;line-height:1;">×</button>
    </div>
    <div id="customersList" style="padding:16px;max-height:72vh;overflow-y:auto;"></div>
  </div>
</div>

<div class="container">

  <!-- JOB SETUP -->
  <div class="card" id="setupCard">
    <div class="card-header">Job Setup</div>
    <div class="card-body">
      <div class="dropdowns" style="margin-bottom:14px;">
        <div class="field-group">
          <label>Customer Type</label>
          <select id="customerType" onchange="onCustomerTypeChange()">
            <option value="carguysinspection">The Car Guys</option>
            <option value="private">Private Customer</option>
            <option value="cash">Cash (No GST)</option>
          </select>
        </div>
        <div class="field-group">
          <label>Report Type</label>
          <select id="reportType">
            <option value="full">Full Inspection</option>
            <option value="service">Service + Inspection</option>
            <option value="safety">Safety Check</option>
            <option value="repair">Repair Only</option>
            <option value="inspection_repair">Inspection + Repair</option>
            <option value="service_repair">Service + Repair</option>
            <option value="safety_repair">Safety Check + Repair</option>
          </select>
        </div>
      </div>
      <div id="privateFields" style="display:none;">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
          <span style="font-size:11px;text-transform:uppercase;letter-spacing:0.7px;color:#6b7a99;font-family:'Courier New',monospace;">Customer Details</span>
          <button class="btn-header" style="font-size:11px;padding:4px 10px;background:#2a3f6f;" onclick="showCustomers()">👤 Saved Customers</button>
        </div>
        <div class="preview-grid" style="margin-bottom:14px;">
          <div class="field-group">
            <label>Customer Name</label>
            <input type="text" id="custName" placeholder="Mark Crocetta" oninput="customerAutocomplete(this)">
            <div id="custAutocomplete" style="display:none;position:absolute;background:white;border:1.5px solid #dde2ed;border-radius:7px;box-shadow:0 4px 12px rgba(0,0,0,0.12);z-index:50;min-width:200px;"></div>
          </div>
          <div class="field-group">
            <label>Mobile</label>
            <input type="text" id="custMobile" placeholder="+61 400 000 000">
          </div>
          <div class="field-group full-width">
            <label>Email</label>
            <input type="text" id="custEmail" placeholder="email@example.com">
          </div>
        </div>
      </div>
      <div class="preview-grid" style="margin-bottom:14px;">
        <div class="field-group">
          <label>Rego</label>
          <input type="text" id="rego" placeholder="1EVI847" style="text-transform:uppercase;" oninput="this.value=this.value.toUpperCase()">
        </div>
        <div class="field-group">
          <label>Date</label>
          <input type="text" id="jobDate" placeholder="DD/MM/YYYY">
        </div>
        <div class="field-group">
          <label>Make</label>
          <input type="text" id="vehicleMake" placeholder="Jeep">
        </div>
        <div class="field-group">
          <label>Model</label>
          <input type="text" id="vehicleModel" placeholder="Cherokee Trailhawk">
        </div>
        <div class="field-group" id="odoField" style="display:none;">
          <label>Odometer (km)</label>
          <input type="text" id="odometer" placeholder="294,498">
        </div>
      </div>
    </div>
  </div>

  <!-- JOB NOTES -->
  <div class="card">
    <div class="card-header">Job Notes</div>
    <div class="card-body">
      <div class="field-group">
        <label>Paste your shorthand notes</label>
        <textarea id="notesInput" placeholder="tf 3.5 3.5&#10;tr0.5 0.5  38psi spare 50psi&#10;27%glycol&#10;690/720cca&#10;lights seat belts wipers doors windows ok no dtcs&#10;replaced 1 x h7 globe&#10;centre bearing split - adv&#10;front lower control arm worn - c&#10;2hrs inspection&#10;..."></textarea>
      </div>
      <div class="notes-hint">Shorthand: Tf/Tr = tyre front/rear · Bf/Br = brakes · Battery: higher=rated lower=tested · Status: ok / adv / c (or advisory / critical)</div>
    </div>
  </div>

  <button class="btn-parse" onclick="parseAndPreview()">▶ Parse &amp; Preview</button>

  <!-- PREVIEW SECTION -->
  <div id="previewSection">

    <!-- RESTORED BANNER -->
    <div id="restoredBanner" style="display:none;" class="restored-banner">
      <div>
        <strong id="restoredBannerTitle">Loaded job</strong>
        <span id="restoredBannerSub" style="font-size:12px;">Editing restored job — generate PDF to save a new version.</span>
      </div>
      <button onclick="document.getElementById('restoredBanner').style.display='none'" style="background:none;border:none;color:#7a4a00;font-size:20px;cursor:pointer;">×</button>
    </div>

    <!-- PARSE SUMMARY BOXES -->
    <div class="parse-summary" id="parseSummary" style="display:none;">
      <div class="parse-box parse-box-captured">
        <h4>✓ Parsed &amp; Captured</h4>
        <p id="parsedList"></p>
      </div>
      <div class="parse-box parse-box-missed">
        <h4>⚠ Not Parsed — Review &amp; Place</h4>
        <p id="missedList"></p>
      </div>
    </div>

    <div id="flagsContainer"></div>

    <!-- VEHICLE EXTERIOR -->
    <div class="card" id="exteriorCard">
      <div class="card-header">Vehicle Exterior</div>
      <div class="card-body">
        <div id="exteriorRows"></div>
        <button class="btn-add-part" onclick="addExteriorRow()">+ Add Row</button>
      </div>
    </div>

    <!-- UNDER BONNET -->
    <div class="card" id="bonnetCard">
      <div class="card-header">Under Bonnet</div>
      <div class="card-body">
        <div id="bonnetRows"></div>
        <div id="bonnetLevelsNote" style="display:none;margin-top:6px;padding:8px 12px;background:#f4f6fa;border-radius:7px;border-left:3px solid #6b7a99;">
          <span style="font-size:11px;text-transform:uppercase;letter-spacing:0.5px;color:#6b7a99;font-family:'Courier New',monospace;">Levels Note</span>
          <input type="text" id="bonnetLevelsNoteText" placeholder="e.g. All levels corrected." style="margin-top:4px;font-size:13px;border:none;background:transparent;padding:0;width:100%;outline:none;color:#1a2744;">
        </div>
        <button class="btn-add-part" onclick="addBonnetRow()" style="margin-top:10px;">+ Add Row</button>
      </div>
    </div>

    <!-- BRAKES & TYRES -->
    <div class="card" id="wheelsCard">
      <div class="card-header">Brakes &amp; Tyres</div>
      <div class="card-body" style="overflow-x:auto;">
        <table class="wheel-table" id="wheelsTable">
          <thead><tr><th>Position</th><th>Tread</th><th>Pressure</th><th>Brakes</th><th>Notes</th><th style="width:30px;"></th></tr></thead>
          <tbody id="wheelsBody"></tbody>
        </table>
        <button class="btn-add-part" onclick="addWheelRow()" style="margin-top:8px;">+ Add Row</button>
        <div style="margin-top:10px;">
          <div class="field-group">
            <label>Tyre Advisory Banner</label>
            <input type="text" id="tyreAdvisory" placeholder="Leave blank if none">
          </div>
        </div>
      </div>
    </div>

    <!-- CHASSIS & BODY -->
    <div class="card collapsible-card" id="chassisCard">
      <div class="card-header collapsible-header" onclick="toggleSection('chassisBody','chassisChevron')">
        Chassis &amp; Body
        <span id="chassisChevron" style="float:right;transition:transform 0.2s;">▼</span>
      </div>
      <div id="chassisBody" class="card-body">
        <table class="wheel-table" style="width:100%;">
          <thead><tr><th style="text-align:left;">Component</th><th>Status</th><th style="text-align:left;">Notes</th><th style="width:30px;"></th></tr></thead>
          <tbody id="chassisRows"></tbody>
        </table>
        <button class="btn-add-finding" style="margin-top:8px;" onclick="addChassisRow()">+ Add Row</button>
      </div>
    </div>

    <!-- REPAIR FINDINGS -->
    <div class="card" id="repairFindingsCard" style="display:none;">
      <div class="card-header">Repair Findings</div>
      <div class="card-body">
        <div id="repairFindingsRows"></div>
        <button class="btn-add-finding" onclick="addFinding('repairFindings')">+ Add Repair Finding</button>
      </div>
    </div>

    <!-- INSPECTION FINDINGS -->
    <div class="card collapsible-card" id="findingsCard" style="display:none;">
      <div class="card-header collapsible-header" onclick="toggleSection('findingsBody','findingsChevron')">
        Inspection Findings
        <span id="findingsChevron" style="float:right;transition:transform 0.2s;">▼</span>
      </div>
      <div id="findingsBody" class="card-body">
        <div id="findingsRows"></div>
        <button class="btn-add-finding" onclick="addFinding('findings')" style="margin-top:4px;">+ Add Finding</button>
      </div>
    </div>

    <!-- FAULT & RECTIFICATION -->
    <div class="card collapsible-card" id="faultCard" style="display:none;">
      <div class="card-header collapsible-header" onclick="toggleSection('faultBody','faultChevron')">
        Fault &amp; Rectification
        <span id="faultChevron" style="float:right;transition:transform 0.2s;">▼</span>
      </div>
      <div id="faultBody" class="card-body">
        <textarea id="faultRect" class="notes-multi" style="min-height:80px;" placeholder="Fault found → what was done → outcome (one item per line)"></textarea>
      </div>
    </div>

    <!-- WORK COMPLETED -->
    <div class="card" id="workCard">
      <div class="card-header">Work Completed</div>
      <div class="card-body">
        <textarea id="workCompleted" class="notes-multi" style="min-height:100px;" placeholder="Work completed – auto-filled from report type and notes"></textarea>
      </div>
    </div>

    <!-- ADDITIONAL NOTES -->
    <div class="card collapsible-card" id="additionalCard" style="display:none;">
      <div class="card-header collapsible-header" style="background:#b05a00;" onclick="toggleSection('additionalBody','additionalChevron')">
        Additional Notes
        <span id="additionalChevron" style="float:right;transition:transform 0.2s;">▼</span>
      </div>
      <div id="additionalBody" class="card-body">
        <div style="font-size:11px;color:#6b7a99;margin-bottom:8px;">Numbered advisory list — shown in orange on the report</div>
        <div id="additionalNotesRows"></div>
        <button class="btn-add-labour" onclick="addAdditionalNote()" style="border-color:#b05a00;color:#b05a00;margin-top:4px;">+ Add Advisory Note</button>
      </div>
    </div>

    <!-- ADD SECTIONS -->
    <div class="card" style="background:#f4f6fa;">
      <div class="card-body" style="padding:12px;">
        <div style="font-size:11px;text-transform:uppercase;letter-spacing:0.7px;color:#6b7a99;font-family:'Courier New',monospace;margin-bottom:10px;">Add Sections</div>
        <div style="display:flex;flex-wrap:wrap;gap:8px;">
          <button class="btn-add-part" style="width:auto;" onclick="showCollapsible('findingsCard','findingsBody','findingsChevron')">+ Inspection Findings</button>
          <button class="btn-add-part" style="width:auto;" onclick="showCollapsible('faultCard','faultBody','faultChevron')">+ Fault &amp; Rectification</button>
          <button class="btn-add-part" style="width:auto;border-color:#b05a00;color:#b05a00;" onclick="showCollapsible('additionalCard','additionalBody','additionalChevron');addAdditionalNote()">+ Additional Notes</button>
        </div>
      </div>
    </div>

    <!-- PARTS SECTIONS -->
    <div class="card collapsible-card" id="reimburseCard" style="display:none;">
      <div class="card-header collapsible-header" onclick="toggleSection('reimburseBody','reimburseChevron')">Parts – Reimbursement<span id="reimburseChevron" style="float:right;">▼</span></div>
      <div id="reimburseBody" class="card-body">
        <div style="display:grid;grid-template-columns:2fr 1fr 1fr 80px 28px;gap:6px;margin-bottom:4px;">
          <span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Item</span><span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Part No.</span><span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Supplier</span><span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Cost</span><span></span>
        </div>
        <div id="reimburseRows"></div>
        <button class="btn-add-part" onclick="addPart('reimburse')" style="margin-top:4px;">+ Add Part</button>
      </div>
    </div>

    <div class="card collapsible-card" id="deductCard" style="display:none;">
      <div class="card-header collapsible-header" onclick="toggleSection('deductBody','deductChevron')">Parts – Deduction (from invoice)<span id="deductChevron" style="float:right;">▼</span></div>
      <div id="deductBody" class="card-body">
        <div style="font-size:12px;color:#6b7a99;margin-bottom:8px;">Parts bought on Car Guys account – repayable deduction from invoice</div>
        <div style="display:grid;grid-template-columns:2fr 1fr 1fr 80px 28px;gap:6px;margin-bottom:4px;">
          <span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Item</span><span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Part No.</span><span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Supplier</span><span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Cost</span><span></span>
        </div>
        <div id="deductRows"></div>
        <button class="btn-add-part" onclick="addPart('deduct')" style="margin-top:4px;">+ Add Part</button>
      </div>
    </div>

    <div class="card collapsible-card" id="stockCard" style="display:none;">
      <div class="card-header collapsible-header" onclick="toggleSection('stockBody','stockChevron')">Car Guys Stock<span id="stockChevron" style="float:right;">▼</span></div>
      <div id="stockBody" class="card-body">
        <div style="display:grid;grid-template-columns:2fr 60px 28px;gap:6px;margin-bottom:4px;">
          <span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Item / Part No.</span><span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Qty</span><span></span>
        </div>
        <div id="stockRows"></div>
        <button class="btn-add-part" onclick="addPart('stock')" style="margin-top:4px;">+ Add Stock Item</button>
      </div>
    </div>

    <div class="card collapsible-card" id="privatePartsCard" style="display:none;">
      <div class="card-header collapsible-header" onclick="toggleSection('privatePartsBody','privatePartsChevron')">Parts (at cost to customer)<span id="privatePartsChevron" style="float:right;">▼</span></div>
      <div id="privatePartsBody" class="card-body">
        <div style="display:grid;grid-template-columns:2fr 1fr 60px 80px 28px;gap:6px;margin-bottom:4px;">
          <span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Item</span><span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Source</span><span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Qty</span><span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Cost</span><span></span>
        </div>
        <div id="privatePartsRows"></div>
        <button class="btn-add-part" onclick="addPart('private')" style="margin-top:4px;">+ Add Part</button>
      </div>
    </div>

    <!-- ADD PARTS -->
    <div class="card" style="background:#f4f6fa;">
      <div class="card-body" style="padding:12px;">
        <div style="font-size:11px;text-transform:uppercase;letter-spacing:0.7px;color:#6b7a99;font-family:'Courier New',monospace;margin-bottom:10px;">Add Parts</div>
        <div style="display:flex;flex-wrap:wrap;gap:8px;">
          <button class="btn-add-part" style="width:auto;" onclick="showCollapsible('reimburseCard','reimburseBody','reimburseChevron');addPart('reimburse')">+ Reimbursement</button>
          <button class="btn-add-part" style="width:auto;" onclick="showCollapsible('deductCard','deductBody','deductChevron');addPart('deduct')">+ Deduction</button>
          <button class="btn-add-part" style="width:auto;" onclick="showCollapsible('stockCard','stockBody','stockChevron');addPart('stock')">+ Car Guys Stock</button>
          <button class="btn-add-part" style="width:auto;border-color:var(--amber);color:var(--amber);" onclick="showCollapsible('privatePartsCard','privatePartsBody','privatePartsChevron');addPart('private')">+ Private Parts</button>
        </div>
      </div>
    </div>

    <!-- LABOUR -->
    <div class="card">
      <div class="card-header">Labour</div>
      <div class="card-body">
        <div style="display:grid;grid-template-columns:3fr 70px 28px;gap:8px;margin-bottom:4px;">
          <span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;">Description</span>
          <span style="font-size:10px;color:#6b7a99;font-family:'Courier New',monospace;text-align:center;">Hours</span>
          <span></span>
        </div>
        <div id="labourRows"></div>
        <button class="btn-add-labour" onclick="addLabourLine()" style="margin-top:4px;">+ Add Labour Line</button>
        <div id="labourTotal" style="display:none;margin-top:10px;padding:10px 12px;background:#1a2744;border-radius:8px;display:flex;justify-content:space-between;align-items:center;">
          <span style="color:white;font-size:13px;font-weight:bold;">Total Labour</span>
          <span id="labourTotalAmt" style="color:#e8a020;font-size:15px;font-weight:bold;"></span>
        </div>
        <div style="margin-top:12px;">
          <div class="field-group">
            <label>Quick checks note (if applicable)</label>
            <input type="text" id="quickChecksDesc" placeholder="e.g. Quick diagnosis checks (3 vehicles)">
          </div>
        </div>
      </div>
    </div>

    <button class="btn-generate" onclick="generatePDF()">⬇ Generate PDF</button>

  </div><!-- end previewSection -->
</div><!-- end container -->

<div class="toast" id="toast"></div>

<script>
// ═══════════════════════════════════════════════════════════
//  CONSTANTS
// ═══════════════════════════════════════════════════════════
const JAMIE = { name:'Jamie Watson', abn:'67 443 578 471', bank:'HSBC', accountName:'Jamie Watson', bsb:'342 201', acct:'185014087' };

const EXTERIOR_ITEMS = [
  {key:'lights',label:'Lights'},{key:'wipers',label:'Wipers'},{key:'seatbelts',label:'Seatbelts'},
  {key:'doors',label:'Doors'},{key:'windows',label:'Windows'},{key:'ac',label:'AC / Heater'},{key:'dtc',label:'DTC Scan'}
];
const BONNET_ITEMS = [
  {key:'belts',label:'Drive Belts'},{key:'hoses',label:'Vacuum & Coolant Hoses'},{key:'battery',label:'Battery'},
  {key:'coolant',label:'Coolant'},{key:'brakefluid',label:'Brake Fluid'},{key:'powersteering',label:'Power Steering Fluid'}
];
const WHEEL_POSITIONS = [
  {key:'lf',label:'Left Front'},{key:'rf',label:'Right Front'},{key:'lr',label:'Left Rear'},{key:'rr',label:'Right Rear'},{key:'spare',label:'Spare'}
];
const CHASSIS_FIXED = ['Transmission','Differentials','Tailshaft / Prop Shaft / Centre Bearing','Driveshafts & CV Boots','Suspension – Front','Suspension – Rear'];
const TYPE_LABELS = {full:'Full Inspection',service:'Service + Inspection',safety:'Safety Check',repair:'Repair Only',inspection_repair:'Inspection + Repair',service_repair:'Service + Repair',safety_repair:'Safety Check + Repair'};

// ═══════════════════════════════════════════════════════════
//  UI HELPERS
// ═══════════════════════════════════════════════════════════
function onCustomerTypeChange(){
  const ct=document.getElementById('customerType').value, isPriv=ct==='private'||ct==='cash';
  document.getElementById('privateFields').style.display=isPriv?'block':'none';
  document.getElementById('odoField').style.display=isPriv?'flex':'none';
}
function toast(msg,dur=2500){ const t=document.getElementById('toast'); t.textContent=msg; t.classList.add('show'); setTimeout(()=>t.classList.remove('show'),dur); }
function isRepairOnly(){ return document.getElementById('reportType').value==='repair'; }
function isCarGuys(){ return document.getElementById('customerType').value==='carguysinspection'; }
function isCash(){ return document.getElementById('customerType').value==='cash'; }
function escHtml(s){ return s?s.replace(/&/g,'&amp;').replace(/"/g,'&quot;'):''; }
function toggleSection(bodyId,chevronId){ const body=document.getElementById(bodyId),chev=document.getElementById(chevronId),open=body.style.display!=='none'; body.style.display=open?'none':'block'; if(chev) chev.style.transform=open?'rotate(-90deg)':'rotate(0deg)'; }
function showCollapsible(cardId,bodyId,chevronId){ document.getElementById(cardId).style.display='block'; document.getElementById(bodyId).style.display='block'; const chev=document.getElementById(chevronId); if(chev) chev.style.transform='rotate(0deg)'; }

// ═══════════════════════════════════════════════════════════
//  DATE HELPERS
// ═══════════════════════════════════════════════════════════
function todayDate(){ const d=new Date(); return `${String(d.getDate()).padStart(2,'0')}/${String(d.getMonth()+1).padStart(2,'0')}/${d.getFullYear()}`; }
function fixDate(str){ if(!str) return todayDate(); const m=str.match(/(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})/); if(!m) return str; let[,d,mo,y]=m; if(y.length===2) y='20'+y; const yr=parseInt(y),now=new Date().getFullYear(); if(Math.abs(yr-now)>1&&Math.abs(yr-now)<3) y=String(now); return `${d.padStart(2,'0')}/${mo.padStart(2,'0')}/${y}`; }

// ═══════════════════════════════════════════════════════════
//  STATUS SHORTHAND HELPER
// ═══════════════════════════════════════════════════════════
// Detects status code at start or end of a line
// Returns { text, status } or null if no status found
function detectStatusLine(line) {
  const ll = line.trim();
  // Patterns: "something - adv", "adv - something", "something advisory", "critical - something" etc
  // Status words: ok, adv, advisory, c, critical (but not 'c' alone if it's part of a word)
  const endPattern = /^(.+?)\s*[-–]\s*(ok|adv|advisory|c|critical)\s*$/i;
  const startPattern = /^(ok|adv|advisory|c|critical)\s*[-–]\s*(.+)$/i;
  const endWordPattern = /^(.+?)\s+(ok|adv|advisory|critical)\s*$/i;
  const startWordPattern = /^(ok|adv|advisory|critical)\s+(.+)$/i;

  let text = '', rawStatus = '';

  let m = ll.match(endPattern) || ll.match(endWordPattern);
  if (m) { text = m[1].trim(); rawStatus = m[2].trim().toLowerCase(); }
  else {
    m = ll.match(startPattern) || ll.match(startWordPattern);
    if (m) { rawStatus = m[1].trim().toLowerCase(); text = m[2].trim(); }
  }

  if (!text || !rawStatus) return null;

  // Map to standard status
  const statusMap = { ok:'OK', adv:'ADVISORY', advisory:'ADVISORY', c:'CRITICAL', critical:'CRITICAL' };
  const status = statusMap[rawStatus];
  if (!status) return null;

  return { text, status };
}

// ═══════════════════════════════════════════════════════════
//  SHORTHAND PARSER — TIGHTENED
// ═══════════════════════════════════════════════════════════
function parseNotes(raw) {
  const lines = raw.split(/\n/).map(l=>l.trim()).filter(Boolean);
  const result = {
    exterior:{lights:null,wipers:null,seatbelts:null,doors:null,windows:null,ac:null,dtc:null},
    bonnet:{belts:null,battery:null,coolant:null,hoses:null,brakefluid:null,powersteering:null,psNA:false,levelsNote:''},
    wheels:{lf:{tread:null,treadNote:null,pressure:null,brakes:null},rf:{tread:null,treadNote:null,pressure:null,brakes:null},lr:{tread:null,treadNote:null,pressure:null,brakes:null},rr:{tread:null,treadNote:null,pressure:null,brakes:null},spare:{pressure:null}},
    tyreAdvisory:'',findings:[],chassis:[],repairFindings:[],workCompleted:[],faultRect:'',additionalNotes:[],labour:[],stock:[],deduct:[],reimburse:[],privateParts:[],
    parsedLines:new Set(), // track which line indices were parsed
    statusLines:[] // lines that have status codes → Inspection Findings
  };

  // ── LABEL PARSING ──
  const labelFields={rego:null,date:null,make:null,model:null,customer:null,odo:null};
  lines.forEach((line,i)=>{
    const labelMatch=line.match(/^(rego|date|model|make|vehicle|customer|odo|odometer)\s*:\s*(.+)/i);
    if(labelMatch){
      const key=labelMatch[1].toLowerCase(),val=labelMatch[2].trim();
      if(key==='rego') labelFields.rego=val.toUpperCase();
      else if(key==='date') labelFields.date=fixDate(val);
      else if(key==='model'||key==='vehicle') labelFields.model=val;
      else if(key==='make') labelFields.make=val;
      else if(key==='customer') labelFields.customer=val;
      else if(key==='odo'||key==='odometer') labelFields.odo=val.replace(/\s*km/i,'').trim();
      result.parsedLines.add(i); return;
    }
    if(i<5){
      if(!labelFields.rego&&line.match(/^[0-9][A-Z]{2,3}[0-9]{2,4}$|^[A-Z]{1,3}[0-9]{2,4}$|^[0-9]{1,3}[A-Z]{2,4}[0-9]{0,3}$/i)){ labelFields.rego=line.toUpperCase(); result.parsedLines.add(i); }
      if(!labelFields.date&&line.match(/^\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4}$/)){ labelFields.date=fixDate(line); result.parsedLines.add(i); }
    }
  });
  if(labelFields.rego){const el=document.getElementById('rego');if(el&&!el.value)el.value=labelFields.rego;}
  if(labelFields.date){const el=document.getElementById('jobDate');if(el)el.value=labelFields.date;}
  if(labelFields.model){
    const parts=labelFields.model.split(/\s+/);
    const knownMakes=['toyota','mazda','holden','ford','jeep','hyundai','kia','mitsubishi','nissan','subaru','honda','bmw','mercedes','audi','volkswagen','vw','isuzu','ldv','great wall','gwm','ram','dodge','chevrolet','gmc','lexus','infiniti','volvo','land rover','landrover','range rover','jaguar','porsche','skoda','seat','alfa','alfa romeo','fiat','peugeot','renault','citroen','suzuki','daihatsu','ssangyong','haval','chery','mg','byd'];
    const makeEl=document.getElementById('vehicleMake'),modelEl=document.getElementById('vehicleModel'),firstWord=parts[0].toLowerCase();
    if(makeEl&&!makeEl.value&&knownMakes.includes(firstWord)){makeEl.value=parts[0].charAt(0).toUpperCase()+parts[0].slice(1);if(modelEl&&!modelEl.value)modelEl.value=parts.slice(1).join(' ');}
    else if(modelEl&&!modelEl.value)modelEl.value=labelFields.model;
  }
  if(labelFields.make){const el=document.getElementById('vehicleMake');if(el&&!el.value)el.value=labelFields.make;}
  if(labelFields.customer){const el=document.getElementById('custName');if(el&&!el.value)el.value=labelFields.customer;}
  if(labelFields.odo){labelFields.odo=labelFields.odo.replace(/,/g,'');const el=document.getElementById('odometer');if(el)el.value=labelFields.odo;}

  // ── STATUS LINES → Inspection Findings ──
  lines.forEach((line,i)=>{
    const detected = detectStatusLine(line);
    if(detected){ result.statusLines.push(detected); result.findings.push({component:detected.text,status:detected.status,notes:''}); result.parsedLines.add(i); }
  });

  // ── TYRES — forgiving: no space after tf/tr, spaces optional before mm/psi ──
  lines.forEach((line,i)=>{
    const ll=line.toLowerCase().trim();
    // tf/tr with optional space: tf3.5 3.5 or tf 3.5 3.5
    // Also handle combined: tr0.5 0.5  38psi (tread AND pressure on same line)
    let m=ll.match(/^t\s*f\s*(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)/i);
    if(m){result.wheels.lf.tread=parseFloat(m[1]);result.wheels.rf.tread=parseFloat(m[2]);result.parsedLines.add(i);}
    m=ll.match(/^t\s*r\s*(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)/i);
    if(m){result.wheels.lr.tread=parseFloat(m[1]);result.wheels.rr.tread=parseFloat(m[2]);result.parsedLines.add(i);}
    // Long form
    m=ll.match(/(?:front\s+tyre[s]?|tyre[s]?\s+front)\s*(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)/i)||ll.match(/^front\s+(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)\s*(?:mm)?$/i);
    if(m){result.wheels.lf.tread=parseFloat(m[1]);result.wheels.rf.tread=parseFloat(m[2]);result.parsedLines.add(i);}
    m=ll.match(/(?:rear\s+tyre[s]?|tyre[s]?\s+rear)\s*(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)/i)||ll.match(/^rear\s+(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)\s*(?:mm)?$/i);
    if(m){result.wheels.lr.tread=parseFloat(m[1]);result.wheels.rr.tread=parseFloat(m[2]);result.parsedLines.add(i);}
    // Corner notes
    const cornerMap=[{keys:['left front','lf'],lk:'lf'},{keys:['right front','rf'],lk:'rf'},{keys:['left rear','lr'],lk:'lr'},{keys:['right rear','rr'],lk:'rr'}];
    cornerMap.forEach(c=>{
      if(c.keys.some(k=>ll.startsWith(k))){
        const noteM=line.match(/outside\s*(\d+(?:\.\d+)?)\s*mm.*inside\s*(\d+(?:\.\d+)?)\s*mm/i);
        if(noteM){result.wheels[c.lk].treadNote=`Tread depth: outside ${noteM[1]}mm / inside ${noteM[2]}mm`;result.wheels[c.lk].tread=Math.min(parseFloat(noteM[1]),parseFloat(noteM[2]));result.parsedLines.add(i);}
        else{const singleM=line.match(/(?:left front|right front|left rear|right rear|lf|rf|lr|rr)\s*(\d+(?:\.\d+)?)\s*mm?/i);if(singleM){result.wheels[c.lk].tread=parseFloat(singleM[1]);result.parsedLines.add(i);}}
      }
    });
  });

  // ── BRAKES — forgiving ──
  lines.forEach((line,i)=>{
    const ll=line.toLowerCase();
    let m=line.match(/^[Bb]\s*[Ff]\s*(\d+(?:\.\d+)?)\s*(\d+(?:\.\d+)?)?/i);
    if(m){result.wheels.lf.brakes=parseFloat(m[1]);result.wheels.rf.brakes=parseFloat(m[2]||m[1]);result.parsedLines.add(i);}
    m=line.match(/^[Bb]\s*[Rr]\s*(\d+(?:\.\d+)?)\s*(\d+(?:\.\d+)?)?/i);
    if(m){result.wheels.lr.brakes=parseFloat(m[1]);result.wheels.rr.brakes=parseFloat(m[2]||m[1]);result.parsedLines.add(i);}
    if(ll.match(/shoe|drum/)){
      result.wheels.lr.shoes=true;result.wheels.rr.shoes=true;
      const sv=line.match(/(\d+(?:\.\d+)?)\s*mm/i)||line.match(/shoe[s]?\s*(\d+(?:\.\d+)?)/i)||line.match(/drum[s]?\s*(\d+(?:\.\d+)?)/i);
      if(sv&&!result.wheels.lr.brakes){result.wheels.lr.brakes=parseFloat(sv[1]);result.wheels.rr.brakes=parseFloat(sv[1]);}
      result.parsedLines.add(i);
    }
  });

  // ── PRESSURE — forgiving: no space before psi, handle on same line as tread ──
  lines.forEach((line,i)=>{
    // Match NNpsi or NN psi (optional space)
    const psiMatches=[...line.matchAll(/(\d+)\s*psi/gi)];
    if(!psiMatches.length) return;
    const lo=line.toLowerCase();
    // Check for spare pressure on same line
    const spareM=lo.match(/spare.*?(\d+)\s*psi/i)||lo.match(/(\d+)\s*psi.*spare/i);
    if(spareM){ result.wheels.spare.pressure=parseInt(spareM[1]); result.parsedLines.add(i); }
    // All round or generic (no position keyword) or front/rear
    psiMatches.forEach(pm=>{
      const psi=parseInt(pm[1]);
      // Skip if this number was the spare
      if(spareM&&pm[1]===spareM[1]&&(lo.indexOf('spare')<lo.indexOf(pm[0])||lo.indexOf(pm[0])<lo.indexOf('spare'))) return;
      if(lo.includes('all')||(!lo.includes('front')&&!lo.includes('rear')&&!lo.includes('spare'))){
        result.wheels.lf.pressure=psi;result.wheels.rf.pressure=psi;result.wheels.lr.pressure=psi;result.wheels.rr.pressure=psi;
      } else if(lo.includes('front')){result.wheels.lf.pressure=psi;result.wheels.rf.pressure=psi;}
      else if(lo.includes('rear')){result.wheels.lr.pressure=psi;result.wheels.rr.pressure=psi;}
      result.parsedLines.add(i);
    });
    // All round with spare: "38psi spare 50psi" or "38 psi spare 50psi"
    const allRoundSpare=line.match(/(\d+)\s*psi\s+spare\s+(\d+)\s*psi/i);
    if(allRoundSpare){
      const p=parseInt(allRoundSpare[1]);
      result.wheels.lf.pressure=p;result.wheels.rf.pressure=p;result.wheels.lr.pressure=p;result.wheels.rr.pressure=p;
      result.wheels.spare.pressure=parseInt(allRoundSpare[2]);
      result.parsedLines.add(i);
    }
  });

  // ── BATTERY — forgiving: no space before cca ──
  const batteryJoined=[];
  for(let i=0;i<lines.length;i++){if(lines[i].match(/^battery/i))batteryJoined.push({text:lines[i]+' '+(lines[i+1]||'')+' '+(lines[i+2]||''),idx:i});else batteryJoined.push({text:lines[i],idx:i});}
  batteryJoined.forEach(({text:line,idx:i})=>{
    const ratedM=line.match(/rated\s*(\d{3,4})\s*cca/i)||line.match(/(\d{3,4})\s*cca\s*rated/i);
    const testedM=line.match(/tested\s*(\d{3,4})/i)||line.match(/(\d{3,4})\s*tested/i);
    if(ratedM&&testedM){result.bonnet.battery={rated:parseInt(ratedM[1]),tested:parseInt(testedM[1])};result.parsedLines.add(i);}
    else{
      // slash format: 690/720cca or 690/720 cca — no space before cca OK
      const slashM=line.match(/(\d{3,4})\s*\/\s*(\d{3,4})\s*cca/i);
      if(slashM){const a=parseInt(slashM[1]),b=parseInt(slashM[2]);result.bonnet.battery={rated:Math.max(a,b),tested:Math.min(a,b)};result.parsedLines.add(i);}
      else if(line.match(/battery/i)){
        const nums=line.match(/\b(\d{3,4})\b/g);
        if(nums&&nums.length>=2){const a=parseInt(nums[0]),b=parseInt(nums[1]);if(line.match(/higher\s*than\s*rated/i)){result.bonnet.battery={rated:Math.min(a,b),tested:Math.max(a,b)};}else{result.bonnet.battery={rated:Math.max(a,b),tested:Math.min(a,b)};}result.parsedLines.add(i);}
      }
    }
  });

  // ── COOLANT — forgiving: no space before %glycol ──
  lines.forEach((line,i)=>{
    // Match: 27%glycol or 27% glycol or coolant 27% or glycol 27%
    const m=line.match(/(\d+)\s*%\s*glycol/i)||line.match(/glycol\s*(\d+)\s*%/i)||line.match(/coolant.*?(\d+)\s*%/i)||line.match(/(\d+)%glycol/i);
    if(m){result.bonnet.coolant=parseInt(m[1]);result.parsedLines.add(i);}
  });

  // ── EXTERIOR — including single-line multi-item ──
  const allLines=raw.toLowerCase();
  const allOk=allLines.match(/(all|everything|windows wipers|all above|all items)\s*(ok|okay|good|fine|clear)/i);
  lines.forEach((line,i)=>{
    const ll=line.toLowerCase();
    // Single line with multiple items: "lights seat belts wipers doors windows ok no dtcs"
    const isMultiOk=ll.match(/ok/i)&&(ll.match(/light|wiper|seatbelt|seat belt|door|window|ac|a\/c/i));
    if(isMultiOk){
      if(ll.match(/light/)&&!ll.match(/coolant|highlight/)){result.exterior.lights={status:'ok',note:''};result.parsedLines.add(i);}
      if(ll.match(/wiper/)){result.exterior.wipers={status:'ok',note:''};result.parsedLines.add(i);}
      if(ll.match(/seatbelt|seat\s*belt/)){result.exterior.seatbelts={status:'ok',note:''};result.parsedLines.add(i);}
      if(ll.match(/\bdoor\b/)){result.exterior.doors={status:'ok',note:''};result.parsedLines.add(i);}
      if(ll.match(/window/)){result.exterior.windows={status:'ok',note:''};result.parsedLines.add(i);}
      if(ll.match(/ac|a\/c|heater|air\s*con/)){result.exterior.ac={status:'ok',note:''};result.parsedLines.add(i);}
    }
    if(ll.match(/dtc|scan|obd|fault\s*code/)){
      if(ll.match(/no\s*dtc|no\s*fault|clear|ok/i)){result.exterior.dtc={status:'ok',note:''};result.parsedLines.add(i);}
      else if(ll.match(/historic|not current|no mil/i)){result.exterior.dtc={status:'caution',note:line};result.parsedLines.add(i);}
      else if(ll.match(/p[0-9]|b[0-9]|c[0-9]|u[0-9]|active|fault/i)){result.exterior.dtc={status:'fault',note:line};result.parsedLines.add(i);}
    }
    if(!isMultiOk){
      if(ll.match(/window/)){ if(ll.match(/sticky|regulator|fault|caution/i)){result.exterior.windows={status:'caution',note:line};result.parsedLines.add(i);}else if(ll.match(/ok|fine|good|clear/i)||allOk){result.exterior.windows={status:'ok',note:''};result.parsedLines.add(i);} }
      if(ll.match(/light/)&&!ll.match(/coolant|highlight/)){ if(ll.match(/ok|fine|good|clear/i)||allOk){result.exterior.lights={status:'ok',note:''};result.parsedLines.add(i);} }
      if(ll.match(/wiper/)){ if(ll.match(/ok|fine|good|clear/i)||allOk){result.exterior.wipers={status:'ok',note:''};result.parsedLines.add(i);} }
      if(ll.match(/seatbelt|seat\s*belt/)){ if(ll.match(/ok|fine|good|clear/i)||allOk){result.exterior.seatbelts={status:'ok',note:''};result.parsedLines.add(i);} }
      if(ll.match(/\bdoor\b/)){ if(ll.match(/ok|fine|good|clear/i)||allOk){result.exterior.doors={status:'ok',note:''};result.parsedLines.add(i);} }
      if(ll.match(/ac|a\/c|heater|air\s*con/)){ if(ll.match(/ok|fine|good|clear/i)||allOk){result.exterior.ac={status:'ok',note:''};result.parsedLines.add(i);} }
    }
  });
  if(allOk){['lights','wipers','seatbelts','doors','windows','ac'].forEach(k=>{if(!result.exterior[k])result.exterior[k]={status:'ok',note:''};});if(!result.exterior.dtc&&allLines.match(/scan|dtc|obd/i))result.exterior.dtc={status:'ok',note:''};}

  // ── UNDER BONNET ──
  lines.forEach((line,i)=>{
    const ll=line.toLowerCase();
    if(ll.match(/drive\s*belt|^belt/i)||ll.match(/belt[s]?\s*(ok|good|fine|clear|no issue)/i)){if(ll.match(/wear|crack|replace|caution|split/i)){result.bonnet.belts={status:'caution',note:line};result.parsedLines.add(i);}else if(ll.match(/ok|fine|good|clear|no issue|all good/i)){result.bonnet.belts={status:'ok',note:''};result.parsedLines.add(i);}}
    if(ll.match(/hose/)){ if(ll.match(/crack|split|leak|perish|wear|replace|caution|deteriorat/i)){result.bonnet.hoses={status:'caution',note:line};result.parsedLines.add(i);}else if(ll.match(/ok|fine|good|clear|no issue|all good/i)){result.bonnet.hoses={status:'ok',note:''};result.parsedLines.add(i);} }
    if(ll.match(/^c\+r$|charge\s*and\s*retest|c\s*\+\s*r/i)){result.bonnet.battery=result.bonnet.battery||{};result.bonnet.battery.cr=true;if(!result.bonnet.battery.rated)result.bonnet.battery={rated:null,tested:null,cr:true};result.parsedLines.add(i);}
    if(ll.match(/brake\s*fluid|brake\s*fl/i)){if(ll.match(/contaminat|dirty|dark|flush|replace|fail/i)){result.bonnet.brakefluid={status:'fault',note:line};result.parsedLines.add(i);}else if(ll.match(/low|top|caution/i)){result.bonnet.brakefluid={status:'caution',note:line};result.parsedLines.add(i);}else if(ll.match(/ok|fine|good|clear|full/i)){result.bonnet.brakefluid={status:'ok',note:''};result.parsedLines.add(i);}}
    if(ll.match(/power\s*steer|p\/s|ps\s*fluid/i)){if(ll.match(/n\/a|na|not\s*applicable|electric|no\s*p\/s|no\s*ps/i)){result.bonnet.psNA=true;result.parsedLines.add(i);}else if(ll.match(/contaminat|dirty|dark|flush|replace|fail/i)){result.bonnet.powersteering={status:'fault',note:line};result.parsedLines.add(i);}else if(ll.match(/low|top|caution/i)){result.bonnet.powersteering={status:'caution',note:line};result.parsedLines.add(i);}else if(ll.match(/ok|fine|good|clear|full/i)){result.bonnet.powersteering={status:'ok',note:''};result.parsedLines.add(i);}}
    if(ll.match(/level|topped|top.?up|corrected/i)&&!ll.match(/oil\s*level|coolant\s*level/i)){if(ll.match(/corrected|topped|top.?up/i)){if(ll.match(/power\s*steer|p\/s/i))result.bonnet.levelsNote=(result.bonnet.levelsNote?result.bonnet.levelsNote+' ':'')+' Power steering fluid topped up.';else if(ll.match(/brake/i))result.bonnet.levelsNote=(result.bonnet.levelsNote?result.bonnet.levelsNote+' ':'')+' Brake fluid topped up.';else result.bonnet.levelsNote='All levels corrected.';result.parsedLines.add(i);}}
  });

  // ── TYRE ADVISORY ──
  lines.forEach((line,i)=>{
    if(line.match(/rotate.*balance|balance.*rotate/i)){result.tyreAdvisory='⚠ Rotate and balance recommended. Wheel alignment advised when tyres replaced.';result.parsedLines.add(i);}
    if(line.match(/require.*rear.*tyre|rear tyre.*replac/i)&&line.match(/align/i)){result.tyreAdvisory='Replace rear tyres. Recommend wheel alignment';result.parsedLines.add(i);}
    if(line.match(/wheel\s*alignment.*strongly|alignment.*strongly/i)){result.tyreAdvisory='⚠ Wheel alignment strongly recommended.';result.parsedLines.add(i);}
  });

  // ── LABOUR ──
  const labourExclude=/spare|pressure|psi|tyre|tread|brake(?!\s*pad|\s*shoe|\s*disc|\s*drum|\s*r&r)|coolant|battery|glycol|odo|date|rego|customer|model|make/i;
  lines.forEach((line,i)=>{
    const ll=line.toLowerCase();
    if(ll.match(/^(rego|date|model|make|vehicle|customer|odo|tf|tr|bf|br|no\s*dtc|dtc|coolant|battery|rated|tested|glycol|levels|belt|hose|p\/s)/i)) return;
    const totalM=line.match(/^total\s+(\d+(?:\.\d+)?)\s*h(?:rs?|ours?)?/i);if(totalM){result.labour.push({desc:'Labour',hrs:parseFloat(totalM[1])});result.parsedLines.add(i);return;}
    const m=line.match(/^(\d+(?:\.\d+)?)\s*h(?:rs?|ours?)\s+(.+)/i)||line.match(/^(.+?)\s+(\d+(?:\.\d+)?)\s*h(?:rs?|ours?)\s*$/i);
    if(m){let hrs,desc;if(line.match(/^\d+(?:\.\d+)?\s*h/i)){hrs=parseFloat(m[1]);desc=m[2].trim();}else{desc=m[1].trim();hrs=parseFloat(m[2]);}desc=desc.replace(/^[-–·\s]+|[-–·\s]+$/g,'').trim();if(desc.length>1&&!desc.match(labourExclude))result.labour.push({desc:desc.charAt(0).toUpperCase()+desc.slice(1),hrs});else if(hrs>0)result.labour.push({desc:'Labour',hrs});result.parsedLines.add(i);return;}
    const plain=line.match(/^(\d+(?:\.\d+)?)\s*h(?:rs?|ours?)?\s*$/i);if(plain){result.labour.push({desc:'Labour',hrs:parseFloat(plain[1])});result.parsedLines.add(i);return;}
  });

  // ── ACTION LINES (work completed) ──
  const actionVerbs=/^(replaced|removed|refitted|repaired|installed|fitted|changed|flushed|topped|adjusted|tightened|washed|cleaned|diagnosed|tested|scanned|reset|updated|recalibrated|programmed|charged|recharged|bled|sealed|torqued|lubricated|inspected and)/i;
  lines.forEach((line,i)=>{if(line.match(actionVerbs)){result.parsedLines.add(i);}});

  // ── WORK COMPLETED ──
  const rt=document.getElementById('reportType').value;
  if(rt==='service'||rt==='service_repair') result.workCompleted.push('A service performed – engine oil and filter replaced. Full inspection completed – see tables above for all findings.');
  else if(rt==='full'||rt==='inspection_repair') result.workCompleted.push('Full inspection completed – see tables above for all findings.');
  else if(rt==='safety'||rt==='safety_repair') result.workCompleted.push('Safety check performed.');
  else if(rt==='repair') result.workCompleted.push('Repair completed – see findings above.');
  lines.forEach(line=>{if(line.match(actionVerbs)){if(!line.match(/engine oil|oil filter/i)||rt!=='service')result.workCompleted.push(line);}});

  return result;
}

// ═══════════════════════════════════════════════════════════
//  BUILD PARSE SUMMARY
// ═══════════════════════════════════════════════════════════
function buildParseSummary(parsed, raw) {
  const lines = raw.split(/\n/).map(l=>l.trim()).filter(Boolean);
  const captured = [];
  const missed = [];

  // Build captured summary
  const w=parsed.wheels;
  if(w.lf.tread||w.rf.tread) captured.push(`Tyres front: LF ${w.lf.tread||'?'}mm · RF ${w.rf.tread||'?'}mm`);
  if(w.lr.tread||w.rr.tread) captured.push(`Tyres rear: LR ${w.lr.tread||'?'}mm · RR ${w.rr.tread||'?'}mm`);
  if(w.lf.brakes||w.rf.brakes) captured.push(`Brakes front: LF ${w.lf.brakes||'?'}mm · RF ${w.rf.brakes||'?'}mm`);
  if(w.lr.brakes||w.rr.brakes) captured.push(`Brakes rear: LR ${w.lr.brakes||'?'}mm · RR ${w.rr.brakes||'?'}mm`);
  const hasPressure=w.lf.pressure||w.lr.pressure||w.spare.pressure;
  if(hasPressure){
    let pStr='Pressures:';
    if(w.lf.pressure) pStr+=` All ${w.lf.pressure} PSI`;
    if(w.spare.pressure) pStr+=` · Spare ${w.spare.pressure} PSI`;
    captured.push(pStr);
  }
  if(parsed.bonnet.battery){const b=parsed.bonnet.battery;if(b.rated&&b.tested){const pct=Math.round((b.tested/b.rated)*100);captured.push(`Battery: Rated ${b.rated} / Tested ${b.tested} CCA – ${b.tested>=b.rated?'100%+':pct+'%'}`);}else if(b.cr)captured.push('Battery: Charge & retest');}
  if(parsed.bonnet.coolant!==null&&parsed.bonnet.coolant!==undefined) captured.push(`Coolant: Glycol ${parsed.bonnet.coolant}%`);
  const extOk=EXTERIOR_ITEMS.filter(it=>parsed.exterior[it.key]&&parsed.exterior[it.key].status==='ok').map(it=>it.label);
  const extFault=EXTERIOR_ITEMS.filter(it=>parsed.exterior[it.key]&&parsed.exterior[it.key].status!=='ok').map(it=>`${it.label} ⚠`);
  if(extOk.length) captured.push(`Exterior OK: ${extOk.join(' · ')}`);
  if(extFault.length) captured.push(`Exterior flags: ${extFault.join(' · ')}`);
  if(parsed.labour.length) captured.push(`Labour: ${parsed.labour.map(l=>`${l.hrs}hrs ${l.desc}`).join(' · ')}`);
  if(parsed.findings.length) captured.push(`Findings: ${parsed.findings.map(f=>`${f.component} (${f.status})`).join(' · ')}`);
  if(parsed.tyreAdvisory) captured.push(`Advisory: ${parsed.tyreAdvisory}`);

  // Missed = lines not in parsedLines
  lines.forEach((line,i)=>{
    if(!parsed.parsedLines.has(i) && line.length>2) missed.push(line);
  });

  const parsedBox=document.getElementById('parsedList');
  const missedBox=document.getElementById('missedList');
  const summaryDiv=document.getElementById('parseSummary');

  parsedBox.textContent=captured.length?captured.join('\n'):'Nothing detected — check your notes format.';
  missedBox.textContent=missed.length?missed.join('\n'):'All lines accounted for ✓';
  summaryDiv.style.display='grid';
}

// ═══════════════════════════════════════════════════════════
//  BUILD PREVIEW UI
// ═══════════════════════════════════════════════════════════
function parseAndPreview(){
  const notes=document.getElementById('notesInput').value.trim();
  if(!notes){toast('Please enter your job notes first.');return;}
  const dateEl=document.getElementById('jobDate');
  if(dateEl.value)dateEl.value=fixDate(dateEl.value);else dateEl.value=todayDate();
  const parsed=parseNotes(notes);
  const repairOnly=isRepairOnly();
  const rt=document.getElementById('reportType').value;
  const isSafety=rt==='safety'||rt==='safety_repair';

  ['exteriorCard','bonnetCard','wheelsCard'].forEach(id=>{document.getElementById(id).style.display=repairOnly?'none':'block';});
  document.getElementById('repairFindingsCard').style.display=repairOnly?'block':'none';
  document.getElementById('chassisCard').style.display=(repairOnly||isSafety)?'none':'block';
  ['faultCard','additionalCard','reimburseCard','deductCard','stockCard','privatePartsCard'].forEach(id=>{document.getElementById(id).style.display='none';});

  // Show findings card if we have status lines
  if(parsed.findings.length>0){
    showCollapsible('findingsCard','findingsBody','findingsChevron');
  } else {
    document.getElementById('findingsCard').style.display='none';
  }

  if(!isCarGuys()) showCollapsible('privatePartsCard','privatePartsBody','privatePartsChevron');

  buildExteriorUI(parsed.exterior);
  buildBonnetUI(parsed.bonnet);
  buildWheelsUI(parsed.wheels,parsed.tyreAdvisory);
  buildChassisUI(parsed);
  buildFindingsTableUI('repairFindings',parsed.repairFindings);
  buildFindingsTableUI('findings',parsed.findings);
  buildLabourUI(parsed.labour);
  document.getElementById('workCompleted').value=parsed.workCompleted.join('\n');
  document.getElementById('faultRect').value='';
  document.getElementById('restoredBanner').style.display='none';
  buildFlags(parsed);
  buildParseSummary(parsed,notes);

  document.getElementById('previewSection').style.display='block';
  document.getElementById('previewSection').scrollIntoView({behavior:'smooth'});
  autosave();
  toast('✓ Parsed! Review and edit below.');
}

// ═══════════════════════════════════════════════════════════
//  UI BUILDERS
// ═══════════════════════════════════════════════════════════
function buildExteriorUI(ext){
  const container=document.getElementById('exteriorRows');container.innerHTML='';
  EXTERIOR_ITEMS.forEach(item=>{
    const val=ext[item.key],status=val?val.status:'unknown',note=val?val.note:'';
    container.appendChild(makeExteriorRow(item.label,`ext_${item.key}_status`,`ext_${item.key}_note`,status,note,false));
  });
}

function makeExteriorRow(label,statusId,noteId,status,note,removable){
  const div=document.createElement('div');div.style.cssText='margin-bottom:10px;';
  div.innerHTML=`<span style="font-size:12px;font-weight:bold;color:#1a2744;display:block;margin-bottom:4px;">${label}</span>
  <div style="display:grid;grid-template-columns:130px 1fr${removable?' 28px':''};gap:8px;align-items:center;">
    <select id="${statusId||''}"><option value="ok" ${status==='ok'?'selected':''}>✓ OK</option><option value="caution" ${status==='caution'?'selected':''}>■ CAUTION</option><option value="fault" ${status==='fault'?'selected':''}>✗ FAULT</option><option value="unknown" ${status==='unknown'?'selected':''}>— Not set</option></select>
    <input type="text" id="${noteId||''}" value="${escHtml(note)}" placeholder="Notes (leave blank if OK)">
    ${removable?`<button class="btn-remove" onclick="this.closest('div').parentElement.remove()">×</button>`:''}
  </div>`;
  return div;
}

function addExteriorRow(){
  const container=document.getElementById('exteriorRows');
  const div=document.createElement('div');div.style.cssText='margin-bottom:10px;';
  div.innerHTML=`<div style="display:grid;grid-template-columns:1fr 130px 1fr 28px;gap:8px;align-items:center;">
    <input type="text" placeholder="Item label" style="font-size:13px;">
    <select><option value="ok">✓ OK</option><option value="caution">■ CAUTION</option><option value="fault">✗ FAULT</option><option value="unknown">— Not set</option></select>
    <input type="text" placeholder="Notes">
    <button class="btn-remove" onclick="this.closest('div').parentElement.remove()">×</button>
  </div>`;
  container.appendChild(div);
}

function buildBonnetUI(bonnet){
  const container=document.getElementById('bonnetRows');container.innerHTML='';
  const belts=bonnet.belts||{status:'unknown',note:''};addBonnetRowEl(container,'belts','Drive Belts',belts.status,belts.note);
  const hoses=bonnet.hoses||{status:'unknown',note:''};addBonnetRowEl(container,'hoses','Vacuum & Coolant Hoses',hoses.status,hoses.note);
  let battNote='',battStatus='unknown';
  if(bonnet.battery){const b=bonnet.battery;if(b.cr&&(!b.rated||!b.tested)){battNote='Charge and retest';battStatus='caution';}else if(b.rated&&b.tested){const pct=Math.round((b.tested/b.rated)*100);battNote=`Rated ${b.rated} CCA / Tested ${b.tested} CCA – ${b.tested>=b.rated?'100%+':pct+'%'}`;if(b.cr)battNote+=' – Charge and retest';if(b.tested>=b.rated)battStatus='ok';else if(pct>=75)battStatus='ok';else if(pct>=50)battStatus='caution';else battStatus='fault';if(b.cr)battStatus='caution';}}
  addBonnetRowEl(container,'battery','Battery',battStatus,battNote);
  let coolNote='',coolStatus='unknown';
  if(bonnet.coolant!==null&&bonnet.coolant!==undefined){coolNote=`Glycol ${bonnet.coolant}%`;if(bonnet.coolant>=20)coolStatus='ok';else if(bonnet.coolant>=10)coolStatus='caution';else coolStatus='fault';}
  addBonnetRowEl(container,'coolant','Coolant',coolStatus,coolNote);
  const bf=bonnet.brakefluid||{status:'unknown',note:''};addBonnetRowEl(container,'brakefluid','Brake Fluid',bf.status,bf.note);
  if(!bonnet.psNA){const ps=bonnet.powersteering||{status:'unknown',note:''};addBonnetRowEl(container,'powersteering','Power Steering Fluid',ps.status,ps.note);}
  const levNote=bonnet.levelsNote||'';
  const levDiv=document.getElementById('bonnetLevelsNote'),levInput=document.getElementById('bonnetLevelsNoteText');
  if(levNote){levDiv.style.display='block';levInput.value=levNote;}else{levDiv.style.display='none';levInput.value='';}
}

function addBonnetRowEl(container,key,label,status,note){
  const div=document.createElement('div');div.style.cssText='margin-bottom:10px;';
  div.innerHTML=`<span style="font-size:12px;font-weight:bold;color:#1a2744;display:block;margin-bottom:4px;">${label}</span>
  <div style="display:grid;grid-template-columns:130px 1fr;gap:8px;align-items:center;">
    <select id="bon_${key}_status"><option value="ok" ${status==='ok'?'selected':''}>✓ OK</option><option value="caution" ${status==='caution'?'selected':''}>■ CAUTION</option><option value="fault" ${status==='fault'?'selected':''}>✗ FAULT</option><option value="unknown" ${status==='unknown'?'selected':''}>— Not set</option></select>
    <input type="text" id="bon_${key}_note" value="${escHtml(note)}" placeholder="Notes (leave blank if OK)">
  </div>`;
  container.appendChild(div);
}

function addBonnetRow(){
  const container=document.getElementById('bonnetRows');
  const div=document.createElement('div');div.style.cssText='margin-bottom:10px;';
  div.innerHTML=`<div style="display:grid;grid-template-columns:1fr 130px 1fr 28px;gap:8px;align-items:center;">
    <input type="text" placeholder="Item label" style="font-size:13px;">
    <select><option value="ok">✓ OK</option><option value="caution">■ CAUTION</option><option value="fault">✗ FAULT</option><option value="unknown">— Not set</option></select>
    <input type="text" placeholder="Notes">
    <button class="btn-remove" onclick="this.closest('div').parentElement.remove()">×</button>
  </div>`;
  container.appendChild(div);
}

function buildWheelsUI(wheels,advisory){
  const tbody=document.getElementById('wheelsBody');tbody.innerHTML='';
  WHEEL_POSITIONS.forEach(pos=>{
    const w=wheels[pos.key]||{},isSpare=pos.key==='spare';
    const treadVal=isSpare?'—':(w.tread!==null&&w.tread!==undefined?w.tread:'');
    const brakesVal=isSpare?'—':(w.brakes!==null&&w.brakes!==undefined?w.brakes:'');
    const noteVal=w.treadNote||(w.shoes?'(shoes)':'')||'';
    tbody.innerHTML+=`<tr>
      <td style="font-weight:bold;font-size:12px;">${pos.label}</td>
      <td>${isSpare?'—':`<input type="number" step="0.1" id="w_${pos.key}_tread" value="${treadVal}" style="width:60px;text-align:center;">`}</td>
      <td><input type="number" id="w_${pos.key}_psi" value="${w.pressure||''}" style="width:60px;text-align:center;"> <span style="font-size:11px;">PSI</span></td>
      <td>${isSpare?'—':`<input type="number" step="0.1" id="w_${pos.key}_brakes" value="${brakesVal}" style="width:60px;text-align:center;">`}</td>
      <td><input type="text" id="w_${pos.key}_note" value="${escHtml(noteVal)}" placeholder="${isSpare?'spare note':'notes'}" style="width:100%;min-width:80px;"></td>
      <td></td>
    </tr>`;
  });
  document.getElementById('tyreAdvisory').value=advisory||'';
}

function addWheelRow(){
  const tbody=document.getElementById('wheelsBody');
  const tr=document.createElement('tr');
  tr.innerHTML=`
    <td><input type="text" placeholder="Position" style="width:80px;font-size:12px;padding:4px;"></td>
    <td><input type="number" step="0.1" placeholder="mm" style="width:60px;text-align:center;"></td>
    <td><input type="number" placeholder="PSI" style="width:60px;text-align:center;"></td>
    <td><input type="number" step="0.1" placeholder="mm" style="width:60px;text-align:center;"></td>
    <td><input type="text" placeholder="notes" style="width:100%;min-width:80px;"></td>
    <td><button class="btn-remove" onclick="this.closest('tr').remove()">×</button></td>`;
  tbody.appendChild(tr);
}

function buildFindingsTableUI(section,items){
  const container=document.getElementById(section+'Rows');container.innerHTML='';
  (items||[]).forEach(item=>addFindingRow(section,item));
}

function addFinding(section,item){addFindingRow(section,item||{component:'',status:'ADVISORY',notes:''});}

function addFindingRow(section,item){
  const container=document.getElementById(section+'Rows');
  const div=document.createElement('div');div.className='finding-row';
  div.innerHTML=`<input type="text" placeholder="Component / finding" value="${escHtml(item.component||'')}">
    <select><option value="CRITICAL" ${item.status==='CRITICAL'?'selected':''}>CRITICAL</option><option value="ADVISORY" ${item.status==='ADVISORY'?'selected':''}>ADVISORY</option><option value="OK" ${item.status==='OK'?'selected':''}>OK</option></select>
    <input type="text" class="finding-notes" placeholder="Notes" value="${escHtml(item.notes||'')}">
    <button class="btn-remove" onclick="this.parentElement.remove()">×</button>`;
  container.appendChild(div);
}

function buildLabourUI(labourItems){
  const container=document.getElementById('labourRows');container.innerHTML='';
  if(labourItems&&labourItems.length>0)labourItems.forEach(l=>addLabourRow(l));else addLabourRow({desc:'Labour',hrs:''});
  updateLabourTotal();
}
function addLabourLine(){addLabourRow({desc:'',hrs:''});updateLabourTotal();}
function addLabourRow(item){
  const container=document.getElementById('labourRows');
  const div=document.createElement('div');div.className='labour-row';
  div.innerHTML=`<input type="text" placeholder="Labour description" value="${escHtml(item.desc||'')}"><input type="number" step="0.5" placeholder="Hrs" value="${item.hrs||''}" style="text-align:center;" oninput="updateLabourTotal()"><button class="btn-remove" onclick="this.parentElement.remove();updateLabourTotal()">×</button>`;
  container.appendChild(div);
}
function updateLabourTotal(){
  const rate=isCarGuys()?50:70,rows=document.getElementById('labourRows').children;
  let total=0,count=0;
  for(const row of rows){const hrs=parseFloat(row.querySelectorAll('input')[1]?.value)||0;if(hrs>0){total+=hrs*rate;count++;}}
  const bar=document.getElementById('labourTotal'),amt=document.getElementById('labourTotalAmt');
  if(bar&&amt){bar.style.display=count>0?'flex':'none';const totalHrs=Array.from(rows).reduce((s,r)=>s+(parseFloat(r.querySelectorAll('input')[1]?.value)||0),0);amt.textContent=`${totalHrs} hrs = $${total.toFixed(2)} ex GST`;}
}

function addAdditionalNote(item){
  const container=document.getElementById('additionalNotesRows'),idx=container.children.length+1;
  const div=document.createElement('div');div.className='additional-note-row';
  div.innerHTML=`<span class="note-num">${idx}</span><select><option value="amber" ${item&&item.urgency==='amber'?'selected':''}>Advisory</option><option value="red" ${item&&item.urgency==='red'?'selected':''}>⚠ Urgent</option></select><input type="text" placeholder="Advisory note" value="${escHtml(item&&item.note||'')}"><button class="btn-remove" onclick="this.parentElement.remove()">×</button>`;
  container.appendChild(div);
}

function buildChassisUI(parsed){
  const tbody=document.getElementById('chassisRows');tbody.innerHTML='';
  const notesRaw=document.getElementById('notesInput').value.toLowerCase();
  CHASSIS_FIXED.forEach(label=>{
    const naHints={transmission:/trans\s*n\/a|no\s*trans/i,differentials:/diff\s*n\/a|no\s*diff|2wd/i,tailshaft:/tail\s*n\/a|no\s*tail|fwd/i,driveshafts:/cv\s*n\/a|no\s*cv/i};
    const hideKey=Object.keys(naHints).find(k=>label.toLowerCase().includes(k));
    if(hideKey&&naHints[hideKey].test(notesRaw))return;
    addChassisTableRow(tbody,label,'unknown','');
  });
}
function addChassisRow(){addChassisTableRow(document.getElementById('chassisRows'),'','unknown','');}
function addChassisTableRow(tbody,label,status,notes){
  const tr=document.createElement('tr');
  tr.innerHTML=`<td><input type="text" value="${escHtml(label)}" placeholder="Component" style="width:100%;font-size:12px;padding:5px;"></td>
    <td><select style="font-size:11px;padding:4px;width:100%;"><option value="unknown" ${status==='unknown'?'selected':''}>— ?</option><option value="OK" ${status==='OK'?'selected':''}>✓ OK</option><option value="ADVISORY" ${status==='ADVISORY'?'selected':''}>Advisory</option><option value="CRITICAL" ${status==='CRITICAL'?'selected':''}>Critical</option></select></td>
    <td><input type="text" value="${escHtml(notes)}" placeholder="Notes" style="width:100%;font-size:12px;padding:5px;"></td>
    <td><button class="btn-remove" onclick="this.closest('tr').remove()">×</button></td>`;
  tbody.appendChild(tr);
}

function addPart(type){
  const containerId={stock:'stockRows',deduct:'deductRows',reimburse:'reimburseRows',private:'privatePartsRows'}[type];
  const container=document.getElementById(containerId);
  const div=document.createElement('div');
  if(type==='stock'){div.style.cssText='display:grid;grid-template-columns:2fr 60px 28px;gap:6px;margin-bottom:6px;align-items:center;';div.innerHTML=`<input type="text" placeholder="Item / Part No." style="font-size:13px;"><input type="number" placeholder="Qty" style="text-align:center;font-size:13px;"><button class="btn-remove" onclick="this.parentElement.remove()">×</button>`;}
  else if(type==='deduct'||type==='reimburse'){div.style.cssText='display:grid;grid-template-columns:2fr 1fr 1fr 80px 28px;gap:6px;margin-bottom:6px;align-items:center;';div.innerHTML=`<input type="text" placeholder="Item" style="font-size:13px;"><input type="text" placeholder="Part No." style="font-size:13px;"><input type="text" placeholder="Supplier" style="font-size:13px;"><input type="number" step="0.01" placeholder="0.00" style="font-size:13px;"><button class="btn-remove" onclick="this.parentElement.remove()">×</button>`;}
  else if(type==='private'){div.style.cssText='display:grid;grid-template-columns:2fr 1fr 60px 80px 28px;gap:6px;margin-bottom:6px;align-items:center;';div.innerHTML=`<input type="text" placeholder="Item" style="font-size:13px;"><input type="text" placeholder="Source" style="font-size:13px;"><input type="number" placeholder="Qty" style="text-align:center;font-size:13px;"><input type="number" step="0.01" placeholder="0.00" style="font-size:13px;"><button class="btn-remove" onclick="this.parentElement.remove()">×</button>`;}
  container.appendChild(div);
}

// ═══════════════════════════════════════════════════════════
//  FLAGS
// ═══════════════════════════════════════════════════════════
function buildFlags(parsed){
  const container=document.getElementById('flagsContainer');container.innerHTML='';
  if(isRepairOnly())return;
  const missing=[];
  const extLabels={lights:'Lights',wipers:'Wipers',seatbelts:'Seatbelts',doors:'Doors',windows:'Windows',ac:'AC/Heater',dtc:'DTC Scan'};
  Object.entries(extLabels).forEach(([k,v])=>{if(!parsed.exterior[k])missing.push({key:k,label:v,section:'ext'});});
  const bonnetLabels={belts:'Drive Belts',hoses:'Hoses',battery:'Battery',coolant:'Coolant',brakefluid:'Brake Fluid',powersteering:'Power Steering'};
  if(!parsed.bonnet.psNA){Object.entries(bonnetLabels).forEach(([k,v])=>{if(!parsed.bonnet[k]&&k!=='powersteering')missing.push({key:k,label:v,section:'bon'});if(k==='powersteering'&&!parsed.bonnet.powersteering&&!parsed.bonnet.psNA)missing.push({key:k,label:v,section:'bon'});});}
  else{Object.entries(bonnetLabels).forEach(([k,v])=>{if(k!=='powersteering'&&!parsed.bonnet[k])missing.push({key:k,label:v,section:'bon'});});}
  if(missing.length>0){const div=document.createElement('div');div.className='flag-banner';div.innerHTML=`<strong>⚠ Not mentioned in notes – please confirm:</strong><div style="font-size:12px;margin-bottom:6px;">${missing.map(m=>m.label).join(', ')}</div><div class="flag-actions"><button class="btn-flag btn-flag-ok" onclick="setAllOk()">All OK</button>${missing.map(m=>`<button class="btn-flag" onclick="setItemOk('${m.section}','${m.key}','${m.label}')">${m.label}</button>`).join('')}</div>`;container.appendChild(div);}
  if(!parsed.labour||parsed.labour.length===0){const div=document.createElement('div');div.className='flag-banner';div.style.borderColor='#c0392b';div.style.background='#fdecea';div.innerHTML=`<strong style="color:#c0392b;">⚠ No hours detected – add labour lines below or the invoice will be $0</strong>`;container.appendChild(div);}
}
function setAllOk(){
  EXTERIOR_ITEMS.forEach(item=>{const sel=document.getElementById(`ext_${item.key}_status`);if(sel&&sel.value==='unknown')sel.value='ok';});
  BONNET_ITEMS.forEach(item=>{const sel=document.getElementById(`bon_${item.key}_status`);if(sel&&sel.value==='unknown')sel.value='ok';});
  document.getElementById('flagsContainer').innerHTML='';toast('All unset items marked ✓ OK');
}
function setItemOk(section,key,label){const sel=document.getElementById(`${section}_${key}_status`);if(sel)sel.value='ok';toast(`${label} set to ✓ OK`);}

// ═══════════════════════════════════════════════════════════
//  COLLECT DATA
// ═══════════════════════════════════════════════════════════
function collectData(){
  const ct=document.getElementById('customerType').value,rt=document.getElementById('reportType').value;
  const cg=isCarGuys(),cash=isCash(),repairOnly=isRepairOnly();
  const data={customerType:ct,reportType:rt,isCarGuys:cg,isCash:cash,isRepairOnly:repairOnly,
    rego:document.getElementById('rego').value.toUpperCase(),date:document.getElementById('jobDate').value||todayDate(),
    make:document.getElementById('vehicleMake').value,model:document.getElementById('vehicleModel').value,
    custName:document.getElementById('custName').value,custMobile:document.getElementById('custMobile').value,
    custEmail:document.getElementById('custEmail').value,odometer:document.getElementById('odometer').value,
    exterior:[],bonnet:[],wheels:[],tyreAdvisory:document.getElementById('tyreAdvisory')?document.getElementById('tyreAdvisory').value:'',
    findings:[],chassis:[],repairFindings:[],
    workCompleted:document.getElementById('workCompleted').value.split('\n').filter(Boolean),
    faultRect:document.getElementById('faultRect').value,additionalNotes:[],labour:[],
    stock:[],deduct:[],reimburse:[],privateParts:[],
    quickChecksDesc:document.getElementById('quickChecksDesc').value
  };

  // Exterior — fixed rows
  EXTERIOR_ITEMS.forEach(item=>{
    const s=document.getElementById(`ext_${item.key}_status`),n=document.getElementById(`ext_${item.key}_note`);
    if(s&&s.value!=='unknown')data.exterior.push({label:item.label,status:s.value,note:n?n.value:''});
  });
  // Exterior — extra rows (no id, just sequential inputs in added divs)
  Array.from(document.getElementById('exteriorRows').children).forEach(div=>{
    const inputs=div.querySelectorAll('input');const sels=div.querySelectorAll('select');
    // Extra rows have a label input as first input
    if(inputs.length>=2&&!inputs[0].id&&inputs[0].value){
      data.exterior.push({label:inputs[0].value,status:sels[0]?sels[0].value:'ok',note:inputs[1].value});
    }
  });

  // Bonnet — fixed rows
  BONNET_ITEMS.forEach(item=>{
    const s=document.getElementById(`bon_${item.key}_status`),n=document.getElementById(`bon_${item.key}_note`);
    if(s&&s.value!=='unknown')data.bonnet.push({label:item.label,status:s.value,note:n?n.value:''});
  });
  // Bonnet — extra rows
  Array.from(document.getElementById('bonnetRows').children).forEach(div=>{
    const inputs=div.querySelectorAll('input');const sels=div.querySelectorAll('select');
    if(inputs.length>=2&&!inputs[0].id&&inputs[0].value){
      data.bonnet.push({label:inputs[0].value,status:sels[0]?sels[0].value:'ok',note:inputs[1].value});
    }
  });
  const levNoteEl=document.getElementById('bonnetLevelsNoteText');data.bonnetLevelsNote=levNoteEl?levNoteEl.value.trim():'';

  // Wheels — fixed rows
  WHEEL_POSITIONS.forEach(pos=>{
    const isSpare=pos.key==='spare';
    const treadEl=document.getElementById(`w_${pos.key}_tread`),psiEl=document.getElementById(`w_${pos.key}_psi`),brakesEl=document.getElementById(`w_${pos.key}_brakes`),noteEl=document.getElementById(`w_${pos.key}_note`);
    const noteVal=noteEl?noteEl.value:'';const isShoes=(pos.key==='lr'||pos.key==='rr')&&noteVal.match(/shoe|drum/i);
    data.wheels.push({label:pos.label,isSpare,tread:treadEl?treadEl.value:null,pressure:psiEl?psiEl.value:null,brakes:brakesEl?brakesEl.value:null,note:noteVal,isShoes:!!isShoes});
  });
  // Wheels — extra rows
  Array.from(document.getElementById('wheelsBody').querySelectorAll('tr')).forEach(tr=>{
    const inputs=tr.querySelectorAll('input');
    if(inputs.length>=5&&!inputs[0].id&&inputs[0].value){
      data.wheels.push({label:inputs[0].value,isSpare:false,tread:inputs[1].value,pressure:inputs[2].value,brakes:inputs[3].value,note:inputs[4].value,isShoes:false});
    }
  });

  data.findingsText='';
  // Findings — table rows
  Array.from((document.getElementById('findingsRows')||{children:[]}).children).forEach(row=>{
    const inputs=row.querySelectorAll('input');const sel=row.querySelector('select');
    if(inputs[0]&&inputs[0].value)data.findings.push({component:inputs[0].value,status:sel?sel.value:'ADVISORY',notes:inputs[1]?inputs[1].value:''});
  });

  // Chassis
  document.getElementById('chassisRows').querySelectorAll('tr').forEach(row=>{
    const inputs=row.querySelectorAll('input'),sel=row.querySelector('select');
    if(inputs[0]&&inputs[0].value&&sel&&sel.value!=='unknown')data.chassis.push({component:inputs[0].value,status:sel.value,notes:inputs[1]?inputs[1].value:''});
  });
  // Repair findings
  Array.from((document.getElementById('repairFindingsRows')||{children:[]}).children).forEach(row=>{
    const inputs=row.querySelectorAll('input,select');if(inputs[0]&&inputs[0].value)data.repairFindings.push({component:inputs[0].value,status:inputs[1].value,notes:inputs[2].value});
  });
  // Additional notes
  Array.from(document.getElementById('additionalNotesRows').children).forEach(row=>{const sel=row.querySelector('select'),inp=row.querySelector('input');if(inp&&inp.value)data.additionalNotes.push({urgency:sel.value,note:inp.value});});
  // Labour
  Array.from(document.getElementById('labourRows').children).forEach(row=>{const inputs=row.querySelectorAll('input');if(inputs[0]&&inputs[1]&&inputs[1].value)data.labour.push({desc:inputs[0].value,hrs:parseFloat(inputs[1].value)||0});});
  // Parts
  Array.from(document.getElementById('stockRows').children).forEach(row=>{const inputs=row.querySelectorAll('input');if(inputs[0]&&inputs[0].value)data.stock.push({item:inputs[0].value,qty:inputs[1]?inputs[1].value:'1'});});
  Array.from(document.getElementById('deductRows').children).forEach(row=>{const inputs=row.querySelectorAll('input');if(inputs[0]&&inputs[0].value)data.deduct.push({item:inputs[0].value,partNo:inputs[1]?inputs[1].value:'',supplier:inputs[2]?inputs[2].value:'',qty:'1',cost:parseFloat(inputs[3]?inputs[3].value:0)||0});});
  Array.from(document.getElementById('reimburseRows').children).forEach(row=>{const inputs=row.querySelectorAll('input');if(inputs[0]&&inputs[0].value)data.reimburse.push({item:inputs[0].value,partNo:inputs[1]?inputs[1].value:'',supplier:inputs[2]?inputs[2].value:'',qty:'1',cost:parseFloat(inputs[3]?inputs[3].value:0)||0});});
  Array.from(document.getElementById('privatePartsRows').children).forEach(row=>{const inputs=row.querySelectorAll('input');if(inputs[0]&&inputs[0].value)data.privateParts.push({item:inputs[0].value,source:inputs[1]?inputs[1].value:'',qty:inputs[2]?inputs[2].value:'1',cost:parseFloat(inputs[3]?inputs[3].value:0)||0});});
  return data;
}

// ═══════════════════════════════════════════════════════════
//  COLOUR HELPERS
// ═══════════════════════════════════════════════════════════
const C={navy:'#1a2744',navyMid:'#2a3f6f',amber:'#e8a020',amberLight:'#fef3dc',red:'#c0392b',redLight:'#fdecea',green:'#1a7a3c',greenLight:'#e8f5ed',grey:'#f4f6fa',white:'#ffffff',textMuted:'#6b7a99'};
function statusBadgePDF(status){const map={ok:{text:'✓ OK',color:C.green,bg:C.greenLight},caution:{text:'■ CAUTION',color:'#7a4a00',bg:C.amberLight},fault:{text:'✗ FAULT',color:C.red,bg:C.redLight},CRITICAL:{text:'CRITICAL',color:C.white,bg:C.red},ADVISORY:{text:'ADVISORY',color:'#7a4a00',bg:C.amberLight},OK:{text:'OK',color:C.green,bg:C.greenLight}};const s=map[status]||map.ok;return{text:s.text,color:s.color,fillColor:s.bg,bold:true,fontSize:9,alignment:'center'};}
function treadColor(mm){if(mm===null||mm===undefined||mm===''||mm==='—')return C.navy;const v=parseFloat(mm);if(isNaN(v))return C.navy;if(v>=4)return C.green;if(v>=3)return '#b07000';return C.red;}
function brakeColor(mm,isShoes){if(mm===null||mm===undefined||mm===''||mm==='—')return C.navy;const v=parseFloat(mm);if(isNaN(v))return C.navy;if(isShoes){if(v>=3)return C.green;if(v>=2)return '#b07000';return C.red;}if(v>=4)return C.green;if(v===3)return '#b07000';return C.red;}
function brakeNote(mm,isShoes){const v=parseFloat(mm);if(isNaN(v))return'';if(isShoes){if(v<2)return'Replace immediately';if(v>=2&&v<3)return'Replace next service';return'';}if(v<=2)return'Replace immediately';if(v===3)return'Replace next service';return'';}

// ═══════════════════════════════════════════════════════════
//  PDF GENERATION
// ═══════════════════════════════════════════════════════════
function generatePDF(){
  const d=collectData();
  if(!d.rego){toast('Please enter a Rego first.');return;}
  const snap=collectCompleteSnapshot();
  const rate=d.isCarGuys?50:70;
  const content=[];

  const titleText=d.isCarGuys?'Contract Mechanic for The Car Guys':'Contract Mechanic';
  const leftHeader=[{text:'Jamie Watson',fontSize:20,bold:true,color:C.navy},{text:titleText,fontSize:10,color:C.textMuted,margin:[0,2,0,0]}];
  let rightRows=[];
  if(d.isCarGuys){rightRows=[[{text:'CUSTOMER',color:C.textMuted,fontSize:9},{text:'The Car Guys',bold:true,color:C.navy,fontSize:10}],[{text:'VEHICLE',color:C.textMuted,fontSize:9},{text:`${d.make} ${d.model}`,bold:true,color:C.navy,fontSize:10}],[{text:'REGO',color:C.textMuted,fontSize:9},{text:d.rego,bold:true,color:C.navy,fontSize:10}],[{text:'DATE',color:C.textMuted,fontSize:9},{text:d.date,bold:true,color:C.navy,fontSize:10}]];}
  else{rightRows=[[{text:'CUSTOMER',color:C.textMuted,fontSize:9},{text:d.custName,bold:true,color:C.navy,fontSize:10}],[{text:'MOBILE',color:C.textMuted,fontSize:9},{text:d.custMobile,bold:true,color:C.navy,fontSize:10}],[{text:'EMAIL',color:C.textMuted,fontSize:9},{text:d.custEmail,bold:true,color:C.navy,fontSize:10}],[{text:'DATE',color:C.textMuted,fontSize:9},{text:d.date,bold:true,color:C.navy,fontSize:10}],[{text:'VEHICLE',color:C.textMuted,fontSize:9},{text:`${d.make} ${d.model}`,bold:true,color:C.navy,fontSize:10}],[{text:'REGO',color:C.textMuted,fontSize:9},{text:d.rego,bold:true,color:C.navy,fontSize:10}],[{text:'ODOMETER',color:C.textMuted,fontSize:9},{text:d.odometer?d.odometer+' km':'—',bold:true,color:C.navy,fontSize:10}]];}
  content.push({columns:[{stack:leftHeader,width:'*'},{width:'auto',table:{body:rightRows,widths:['auto','auto']},layout:'noBorders'}],margin:[0,0,0,8]});
  content.push({canvas:[{type:'line',x1:0,y1:0,x2:515,y2:0,lineWidth:2,lineColor:C.navy}],margin:[0,0,0,12]});

  function sH(title){return{text:title,bold:true,color:C.white,fillColor:C.navy,fontSize:10,margin:[4,4,4,4]};}
  function cH(text,align='center'){return{text,bold:true,color:C.white,fillColor:C.navyMid,fontSize:9,alignment:align,margin:[3,4,3,4]};}
  function dC(text,opts={}){return{text:String(text||''),fontSize:9,color:C.navy,margin:[3,3,3,3],...opts};}
  function rBg(i){return i%2===0?C.white:C.grey;}

  if(!d.isRepairOnly&&d.exterior.length>0){
    const extBody=[[{text:'VEHICLE EXTERIOR',colSpan:3,...sH('VEHICLE EXTERIOR')},{},{}],[cH('ITEM','left'),cH('RESULT'),cH('NOTES','left')]];
    d.exterior.forEach((item,i)=>{const badge=statusBadgePDF(item.status);extBody.push([{...dC(item.label,{bold:true}),fillColor:rBg(i)},{text:badge.text,bold:true,fontSize:9,color:badge.color,fillColor:badge.fillColor,alignment:'center',margin:[3,3,3,3]},{...dC(item.note),fillColor:rBg(i)}]);});
    content.push({table:{widths:[120,80,'*'],body:extBody},layout:{hLineWidth:()=>0.3,vLineWidth:()=>0,hLineColor:()=>C.grey},margin:[0,0,0,12]});
  }

  if(!d.isRepairOnly&&d.bonnet.length>0){
    const bonBody=[[{text:'UNDER BONNET',colSpan:3,...sH('UNDER BONNET')},{},{}],[cH('ITEM','left'),cH('RESULT'),cH('NOTES','left')]];
    d.bonnet.forEach((item,i)=>{const badge=statusBadgePDF(item.status);bonBody.push([{...dC(item.label,{bold:true}),fillColor:rBg(i)},{text:badge.text,bold:true,fontSize:9,color:badge.color,fillColor:badge.fillColor,alignment:'center',margin:[3,3,3,3]},{...dC(item.note),fillColor:rBg(i)}]);});
    content.push({table:{widths:[120,80,'*'],body:bonBody},layout:{hLineWidth:()=>0.3,vLineWidth:()=>0,hLineColor:()=>C.grey},margin:[0,0,d.bonnetLevelsNote?2:12,0]});
    if(d.bonnetLevelsNote)content.push({text:`* ${d.bonnetLevelsNote}`,fontSize:8,italics:true,color:C.textMuted,margin:[4,0,0,12]});
  }

  if(!d.isRepairOnly&&d.wheels.length>0){
    const wtBody=[[{text:'BRAKES & TYRES',colSpan:5,...sH('BRAKES & TYRES')},{},{},{},{}],[cH('POSITION','left'),cH('TREAD DEPTH'),cH('PRESSURE'),cH('BRAKES'),cH('NOTES','left')]];
    d.wheels.forEach((w,i)=>{const isSpare=w.isSpare;const treadVal=isSpare||w.tread===''||w.tread===null?'—':w.tread+'mm';const treadC=isSpare?C.navy:treadColor(w.tread);const shoesFlag=w.isShoes;const brakeDisplay=isSpare||w.brakes===''||w.brakes===null?'—':w.brakes+'mm'+(shoesFlag?' (shoes)':'');const brakeC=isSpare?C.navy:brakeColor(w.brakes,shoesFlag);const autoNote=isSpare?'':brakeNote(w.brakes,shoesFlag);const cleanNote=(w.note||'').replace(/\(?\s*shoes?\s*\)?/gi,'').trim();const noteText=[cleanNote,autoNote].filter(Boolean).join(' · ');wtBody.push([{...dC(w.label,{bold:true}),fillColor:rBg(i)},{text:treadVal,bold:true,color:treadC,fontSize:9,alignment:'center',margin:[3,3,3,3],fillColor:rBg(i)},{...dC(w.pressure?w.pressure+' PSI':'—'),alignment:'center',fillColor:rBg(i)},{text:brakeDisplay,bold:true,color:brakeC,fontSize:9,alignment:'center',margin:[3,3,3,3],fillColor:rBg(i)},{...dC(noteText),fillColor:rBg(i)}]);});
    if(d.tyreAdvisory)wtBody.push([{text:d.tyreAdvisory,colSpan:5,bold:true,fontSize:9,color:'#7a4a00',fillColor:C.amberLight,alignment:'center',margin:[4,5,4,5],border:[false,false,false,false]},{},{},{},{}]);
    content.push({table:{widths:[80,60,55,55,'*'],body:wtBody},layout:{hLineWidth:()=>0.3,vLineWidth:()=>0,hLineColor:()=>C.grey},margin:[0,0,0,12]});
  }

  // Inspection Findings — table format
  if(!d.isRepairOnly&&d.findings&&d.findings.length>0){
    const fBody=[[{text:'INSPECTION FINDINGS',colSpan:3,...sH('INSPECTION FINDINGS')},{},{}],[cH('COMPONENT','left'),cH('STATUS'),cH('NOTES','left')]];
    d.findings.forEach((f,i)=>{const badge=statusBadgePDF(f.status);fBody.push([{...dC(f.component,{bold:true}),fillColor:rBg(i)},{text:badge.text,bold:true,fontSize:9,color:badge.color,fillColor:badge.fillColor,alignment:'center',margin:[3,3,3,3]},{...dC(f.notes),fillColor:rBg(i)}]);});
    content.push({table:{widths:[160,70,'*'],body:fBody},layout:{hLineWidth:()=>0.3,vLineWidth:()=>0,hLineColor:()=>C.grey},margin:[0,0,0,12]});
  }

  if(!d.isRepairOnly&&d.chassis.length>0){
    const cBody=[[{text:'CHASSIS & BODY',colSpan:3,...sH('CHASSIS & BODY')},{},{}],[cH('COMPONENT','left'),cH('STATUS'),cH('NOTES','left')]];
    d.chassis.forEach((f,i)=>{const badge=statusBadgePDF(f.status);cBody.push([{...dC(f.component,{bold:true}),fillColor:rBg(i)},{text:badge.text,bold:true,fontSize:9,color:badge.color,fillColor:badge.fillColor,alignment:'center',margin:[3,3,3,3]},{...dC(f.notes),fillColor:rBg(i)}]);});
    content.push({table:{widths:[160,70,'*'],body:cBody},layout:{hLineWidth:()=>0.3,vLineWidth:()=>0,hLineColor:()=>C.grey},margin:[0,0,0,12]});
  }

  if(d.isRepairOnly&&d.repairFindings.length>0){
    const rBody=[[{text:'REPAIR FINDINGS',colSpan:3,...sH('REPAIR FINDINGS')},{},{}],[cH('COMPONENT','left'),cH('STATUS'),cH('NOTES','left')]];
    d.repairFindings.forEach((f,i)=>{const badge=statusBadgePDF(f.status);rBody.push([{...dC(f.component,{bold:true}),fillColor:rBg(i)},{text:badge.text,bold:true,fontSize:9,color:badge.color,fillColor:badge.fillColor,alignment:'center',margin:[3,3,3,3]},{...dC(f.notes),fillColor:rBg(i)}]);});
    content.push({table:{widths:[120,70,'*'],body:rBody},layout:{hLineWidth:()=>0.3,vLineWidth:()=>0,hLineColor:()=>C.grey},margin:[0,0,0,12]});
  }

  const faultLines=d.faultRect?d.faultRect.split('\n').filter(Boolean):[];
  const wcStack=[{text:'WORK COMPLETED',bold:true,color:C.white,fillColor:C.navy,fontSize:10,margin:[4,4,4,4]}];
  if(d.workCompleted.length>0)d.workCompleted.forEach(line=>wcStack.push({text:'• '+line,fontSize:9,color:C.navy,margin:[4,2,4,2]}));
  if(faultLines.length>0){wcStack.push({text:'Fault & Rectification',bold:true,color:C.navy,fontSize:9,decoration:'underline',margin:[4,8,4,2]});faultLines.forEach(line=>wcStack.push({text:'• '+line,fontSize:9,color:C.navy,margin:[4,2,4,2]}));}
  if(d.additionalNotes.length>0){wcStack.push({text:'Additional Notes',bold:true,color:C.navy,fontSize:9,decoration:'underline',margin:[4,8,4,2]});d.additionalNotes.forEach((note,i)=>{const isUrgent=note.urgency==='red';wcStack.push({text:`(${i+1}) ${note.note}`,fontSize:9,color:isUrgent?C.red:'#b05a00',bold:isUrgent,margin:[4,2,4,2]});});}
  content.push({table:{widths:['*'],body:[[{stack:wcStack}]]},layout:{hLineWidth:()=>0,vLineWidth:()=>0},margin:[0,0,0,12]});

  const hasStock=d.stock.length>0,hasDeduct=d.deduct.length>0,hasReim=d.reimburse.length>0,hasPrivParts=d.privateParts.length>0;
  if(hasStock||hasDeduct||hasReim||hasPrivParts){
    content.push({table:{widths:['*'],body:[[{text:'PARTS & INVENTORY',bold:true,color:C.white,fontSize:10,margin:[4,4,4,4],fillColor:C.navy}]]},layout:{hLineWidth:()=>0,vLineWidth:()=>0},margin:[0,0,0,4]});
    if(hasStock){const sBody=[[{text:'A) Car Guys Stock',colSpan:3,bold:true,fontSize:9,color:C.navy,fillColor:'#e8eef8',margin:[4,4,4,4]},{},{}],[cH('ITEM / PART NO.','left'),cH('QTY'),cH('NOTES','left')]];d.stock.forEach((s,i)=>sBody.push([{...dC(s.item),fillColor:rBg(i)},{...dC(s.qty),alignment:'center',fillColor:rBg(i)},{...dC('Deduct from stock'),fillColor:rBg(i)}]));content.push({table:{widths:['*',60,120],body:sBody},layout:{hLineWidth:()=>0.3,vLineWidth:()=>0,hLineColor:()=>C.grey},margin:[0,4,0,6]});}
    if(hasDeduct){const deductTotal=d.deduct.reduce((s,r)=>s+r.cost,0);const dBody=[[{text:'B) Deductions',colSpan:6,bold:true,fontSize:9,color:C.navy,fillColor:'#e8eef8',margin:[4,4,4,4]},{},{},{},{},{}],[cH('ITEM','left'),cH('PART NO.'),cH('SUPPLIER'),cH('QTY'),cH('COST (ex GST)'),cH('')]];d.deduct.forEach((r,i)=>dBody.push([{...dC(r.item),fillColor:rBg(i)},{...dC(r.partNo),alignment:'center',fillColor:rBg(i)},{...dC(r.supplier),fillColor:rBg(i)},{...dC(r.qty),alignment:'center',fillColor:rBg(i)},{...dC('$'+r.cost.toFixed(2)),alignment:'right',fillColor:rBg(i)},{...dC(''),fillColor:rBg(i)}]));dBody.push([{text:'Deductions Total',colSpan:5,bold:true,fontSize:9,color:C.red,alignment:'right',margin:[3,4,3,4]},{},{},{},{},{text:'–$'+deductTotal.toFixed(2),bold:true,fontSize:9,color:C.red,alignment:'right',margin:[3,4,3,4]}]);content.push({table:{widths:['*',60,70,40,80,60],body:dBody},layout:{hLineWidth:()=>0.3,vLineWidth:()=>0,hLineColor:()=>C.grey},margin:[0,4,0,6]});}
    if(hasReim){const reimTotal=d.reimburse.reduce((s,r)=>s+r.cost,0);const rBody=[[{text:'C) Parts – Reimbursement',colSpan:6,bold:true,fontSize:9,color:C.navy,fillColor:'#e8eef8',margin:[4,4,4,4]},{},{},{},{},{}],[cH('ITEM','left'),cH('PART NO.'),cH('SUPPLIER'),cH('QTY'),cH('COST (ex GST)'),cH('')]];d.reimburse.forEach((r,i)=>rBody.push([{...dC(r.item),fillColor:rBg(i)},{...dC(r.partNo),alignment:'center',fillColor:rBg(i)},{...dC(r.supplier),fillColor:rBg(i)},{...dC(r.qty),alignment:'center',fillColor:rBg(i)},{...dC('$'+r.cost.toFixed(2)),alignment:'right',fillColor:rBg(i)},{...dC(''),fillColor:rBg(i)}]));rBody.push([{text:'Parts Total',colSpan:5,bold:true,fontSize:9,color:C.navy,alignment:'right',margin:[3,4,3,4]},{},{},{},{},{text:'$'+reimTotal.toFixed(2),bold:true,fontSize:9,color:C.navy,alignment:'right',margin:[3,4,3,4]}]);content.push({table:{widths:['*',60,70,40,80,60],body:rBody},layout:{hLineWidth:()=>0.3,vLineWidth:()=>0,hLineColor:()=>C.grey},margin:[0,4,0,6]});}
    if(hasPrivParts){const ppTotal=d.privateParts.reduce((s,r)=>s+r.cost,0);const pBody=[[{text:'Parts (at cost)',colSpan:5,bold:true,fontSize:9,color:C.navy,fillColor:'#e8eef8',margin:[4,4,4,4]},{},{},{},{}],[cH('ITEM','left'),cH('SOURCE'),cH('QTY'),cH('COST'),cH('NOTES')]];d.privateParts.forEach((r,i)=>pBody.push([{...dC(r.item),fillColor:rBg(i)},{...dC(r.source),fillColor:rBg(i)},{...dC(r.qty),alignment:'center',fillColor:rBg(i)},{...dC('$'+r.cost.toFixed(2)),alignment:'right',fillColor:rBg(i)},{...dC('At cost'),fillColor:rBg(i)}]));pBody.push([{text:'Parts Total',colSpan:4,bold:true,fontSize:9,color:C.navy,alignment:'right',margin:[3,4,3,4]},{},{},{},{text:'$'+ppTotal.toFixed(2),bold:true,fontSize:9,color:C.navy,alignment:'right',margin:[3,4,3,4]}]);content.push({table:{widths:['*',80,40,70,70],body:pBody},layout:{hLineWidth:()=>0.3,vLineWidth:()=>0,hLineColor:()=>C.grey},margin:[0,4,0,6]});}
  }

  // ── INVOICE — always starts on new page ──
  const deductTotal=d.deduct.reduce((s,r)=>s+r.cost,0),reimTotal=d.reimburse.reduce((s,r)=>s+r.cost,0),ppTotal=d.privateParts.reduce((s,r)=>s+r.cost,0);
  let labourSubtotal=0;d.labour.forEach(l=>labourSubtotal+=l.hrs*rate);
  const invoiceTitle=d.isCash?'INVOICE':'TAX INVOICE';
  // One line: "From: Jamie Watson · ABN 67 443 578 471"
  const fromLine=d.isCash?JAMIE.name:`${JAMIE.name} · ABN ${JAMIE.abn}`;
  const toLine=d.isCarGuys?'The Car Guys':(d.custName||'Customer');

  const invBody=[
    [{text:invoiceTitle,colSpan:4,bold:true,color:C.white,fillColor:C.navy,fontSize:12,margin:[4,6,4,6]},{},{},{}],
    [{text:`To: ${toLine}`,colSpan:2,fontSize:9,color:C.navy,margin:[4,4,4,4]},{text:''},{},{text:`From: ${fromLine}`,fontSize:9,color:C.navy,alignment:'right',margin:[4,4,4,4],noWrap:true}],
    [cH('DESCRIPTION','left'),cH('HRS'),cH('RATE'),cH('AMOUNT (ex GST)','right')]
  ];
  d.labour.forEach((l,i)=>{
    invBody.push([{...dC(l.desc),fillColor:rBg(i)},{...dC(l.hrs||''),alignment:'center',fillColor:rBg(i)},{...dC(l.hrs?`$${rate}.00/hr`:''),alignment:'center',fillColor:rBg(i)},{...dC(l.hrs?'$'+(l.hrs*rate).toFixed(2):''),alignment:'right',fillColor:rBg(i)}]);
    if(i===0&&d.quickChecksDesc)invBody.push([{text:d.quickChecksDesc,colSpan:4,fontSize:8,color:'#b07000',italics:true,fillColor:C.amberLight,margin:[8,2,4,2]},{},{},{}]);
  });
  if(d.labour.length>1){const totalHrs=d.labour.reduce((s,l)=>s+l.hrs,0);invBody.push([{text:'Total Labour',colSpan:2,bold:true,fontSize:9,color:C.navy,fillColor:'#e8eef8',margin:[4,4,4,4]},{},{text:`${totalHrs} hrs`,bold:true,fontSize:9,color:C.navy,fillColor:'#e8eef8',alignment:'center',margin:[3,4,3,4]},{text:'$'+labourSubtotal.toFixed(2),bold:true,fontSize:9,color:C.navy,fillColor:'#e8eef8',alignment:'right',margin:[3,4,3,4]}]);}
  let rowIdx=d.labour.length;
  if(reimTotal>0){invBody.push([{...dC('Parts – reimbursement (see Parts & Inventory)'),fillColor:rBg(rowIdx)},{...dC('—'),alignment:'center',fillColor:rBg(rowIdx)},{...dC('—'),alignment:'center',fillColor:rBg(rowIdx)},{...dC('$'+reimTotal.toFixed(2)),alignment:'right',fillColor:rBg(rowIdx)}]);rowIdx++;}
  if(ppTotal>0){invBody.push([{...dC('Parts – at cost (see Parts & Inventory)'),fillColor:rBg(rowIdx)},{...dC(''),alignment:'center',fillColor:rBg(rowIdx)},{...dC('At cost'),alignment:'center',fillColor:rBg(rowIdx)},{...dC('$'+ppTotal.toFixed(2)),alignment:'right',fillColor:rBg(rowIdx)}]);rowIdx++;}
  if(deductTotal>0){invBody.push([{...dC('Less: Car Guys stock parts – repayable deduction'),color:C.red,fillColor:rBg(rowIdx)},{...dC('—'),alignment:'center',fillColor:rBg(rowIdx)},{...dC('—'),alignment:'center',fillColor:rBg(rowIdx)},{text:'–$'+deductTotal.toFixed(2),bold:true,color:C.red,fontSize:9,alignment:'right',margin:[3,3,3,3],fillColor:rBg(rowIdx)}]);rowIdx++;}
  const subtotal=labourSubtotal+reimTotal+ppTotal-deductTotal,gst=d.isCash?0:subtotal*0.1,total=subtotal+gst;
  invBody.push([{text:'Subtotal',colSpan:3,bold:true,fontSize:9,alignment:'right',margin:[3,6,3,3],color:C.navy},{},{},{text:'$'+subtotal.toFixed(2),bold:true,fontSize:9,alignment:'right',margin:[3,6,3,3],color:C.navy}]);
  if(!d.isCash)invBody.push([{text:'GST (10%)',colSpan:3,fontSize:9,alignment:'right',margin:[3,2,3,2],color:C.navy},{},{},{text:'$'+gst.toFixed(2),fontSize:9,alignment:'right',margin:[3,2,3,2],color:C.navy}]);
  invBody.push([{text:'TOTAL'+(d.isCash?'':' (inc. GST)'),colSpan:3,bold:true,fontSize:11,alignment:'right',margin:[3,4,3,4],color:C.white,fillColor:C.navy},{},{},{text:'$'+total.toFixed(2),bold:true,fontSize:11,alignment:'right',margin:[3,4,3,4],color:C.white,fillColor:C.navy}]);

  // PAGE BREAK before invoice
  content.push({
    table:{widths:['*',40,70,80],body:invBody},
    layout:{hLineWidth:()=>0.3,vLineWidth:()=>0,hLineColor:()=>C.grey},
    margin:[0,0,0,8],
    pageBreak:'before'
  });

  if(!d.isCash)content.push({text:`Bank: ${JAMIE.bank}   Account: ${JAMIE.accountName}   BSB: ${JAMIE.bsb}   Acct: ${JAMIE.acct}`,fontSize:9,color:C.textMuted,alignment:'center',margin:[0,4,0,0]});
  if(d.isCash)content.push({text:'Cash payment – no GST applied.',fontSize:9,color:'#b07000',italics:true,alignment:'center',margin:[0,4,0,0]});

  content.push({canvas:[{type:'line',x1:0,y1:0,x2:515,y2:0,lineWidth:0.5,lineColor:C.grey}],margin:[0,12,0,6]});
  const footerTitle=d.isCarGuys?'Contract Mechanic for The Car Guys':'Contract Mechanic';
  const abn=d.isCash?'':` · ABN ${JAMIE.abn}`;
  content.push({text:`${JAMIE.name} · ${footerTitle}${abn} · Generated ${d.date}`,fontSize:8,color:C.textMuted,alignment:'center'});
  const footerDisclaimer=d.isRepairOnly?'Repair based on presented faults and diagnosed components only.':'Inspection based on visible components only. Parts requiring disassembly are not inspected unless otherwise stated.';
  content.push({text:footerDisclaimer,fontSize:8,color:C.textMuted,alignment:'center',margin:[0,2,0,0]});

  const docDef={content,defaultStyle:{font:'Roboto',fontSize:10,color:C.navy},pageMargins:[30,30,30,30],pageSize:'A4'};
  const filename=`${d.rego}_${d.make}_${d.model}.pdf`.replace(/\s+/g,'_');
  pdfMake.createPdf(docDef).download(filename);

  saveJobSnapshot(snap,total.toFixed(2));
  saveToHistory(d,total.toFixed(2));
  if(!d.isCarGuys&&d.custName)saveCustomer(d.custName,d.custMobile,d.custEmail);
  toast('✓ PDF generated & job saved!');
  autosave();
}

// ═══════════════════════════════════════════════════════════
//  SNAPSHOT SYSTEM
// ═══════════════════════════════════════════════════════════
function collectCompleteSnapshot(){
  const snap={};
  snap.customerType=document.getElementById('customerType').value;
  snap.reportType=document.getElementById('reportType').value;
  snap.rego=document.getElementById('rego').value.toUpperCase();
  snap.date=document.getElementById('jobDate').value||todayDate();
  snap.make=document.getElementById('vehicleMake').value;
  snap.model=document.getElementById('vehicleModel').value;
  snap.custName=document.getElementById('custName').value;
  snap.custMobile=document.getElementById('custMobile').value;
  snap.custEmail=document.getElementById('custEmail').value;
  snap.odometer=document.getElementById('odometer').value;
  snap.notes=document.getElementById('notesInput').value;
  snap.exterior={};EXTERIOR_ITEMS.forEach(item=>{const s=document.getElementById(`ext_${item.key}_status`),n=document.getElementById(`ext_${item.key}_note`);snap.exterior[item.key]={status:s?s.value:'unknown',note:n?n.value:''};});
  snap.bonnet={};BONNET_ITEMS.forEach(item=>{const s=document.getElementById(`bon_${item.key}_status`),n=document.getElementById(`bon_${item.key}_note`);snap.bonnet[item.key]={status:s?s.value:'unknown',note:n?n.value:''};});
  const levEl=document.getElementById('bonnetLevelsNoteText');snap.bonnetLevelsNote=levEl?levEl.value.trim():'';
  snap.wheels={};WHEEL_POSITIONS.forEach(pos=>{snap.wheels[pos.key]={tread:(document.getElementById(`w_${pos.key}_tread`)||{}).value||'',pressure:(document.getElementById(`w_${pos.key}_psi`)||{}).value||'',brakes:(document.getElementById(`w_${pos.key}_brakes`)||{}).value||'',note:(document.getElementById(`w_${pos.key}_note`)||{}).value||''};});
  snap.tyreAdvisory=(document.getElementById('tyreAdvisory')||{}).value||'';
  snap.chassis=[];document.getElementById('chassisRows').querySelectorAll('tr').forEach(row=>{const inputs=row.querySelectorAll('input'),sel=row.querySelector('select');if(inputs[0]&&inputs[0].value)snap.chassis.push({component:inputs[0].value,status:sel?sel.value:'unknown',notes:inputs[1]?inputs[1].value:''});});
  snap.findings=[];Array.from((document.getElementById('findingsRows')||{children:[]}).children).forEach(row=>{const inputs=row.querySelectorAll('input'),sel=row.querySelector('select');if(inputs[0]&&inputs[0].value)snap.findings.push({component:inputs[0].value,status:sel?sel.value:'ADVISORY',notes:inputs[1]?inputs[1].value:''});});
  snap.repairFindings=[];Array.from((document.getElementById('repairFindingsRows')||{children:[]}).children).forEach(row=>{const inputs=row.querySelectorAll('input,select');if(inputs[0]&&inputs[0].value)snap.repairFindings.push({component:inputs[0].value,status:inputs[1]?inputs[1].value:'CRITICAL',notes:inputs[2]?inputs[2].value:''});});
  snap.faultRect=(document.getElementById('faultRect')||{}).value||'';
  snap.workCompleted=(document.getElementById('workCompleted')||{}).value||'';
  snap.quickChecksDesc=(document.getElementById('quickChecksDesc')||{}).value||'';
  snap.additionalNotes=[];Array.from((document.getElementById('additionalNotesRows')||{children:[]}).children).forEach(row=>{const sel=row.querySelector('select'),inp=row.querySelector('input');if(inp&&inp.value)snap.additionalNotes.push({urgency:sel?sel.value:'amber',note:inp.value});});
  snap.labour=[];Array.from((document.getElementById('labourRows')||{children:[]}).children).forEach(row=>{const inputs=row.querySelectorAll('input');if(inputs[0]&&inputs[1]&&inputs[1].value)snap.labour.push({desc:inputs[0].value,hrs:parseFloat(inputs[1].value)||0});});
  snap.stock=[];Array.from((document.getElementById('stockRows')||{children:[]}).children).forEach(row=>{const inputs=row.querySelectorAll('input');if(inputs[0]&&inputs[0].value)snap.stock.push({item:inputs[0].value,qty:inputs[1]?inputs[1].value:'1'});});
  snap.deduct=[];Array.from((document.getElementById('deductRows')||{children:[]}).children).forEach(row=>{const inputs=row.querySelectorAll('input');if(inputs[0]&&inputs[0].value)snap.deduct.push({item:inputs[0].value,partNo:inputs[1]?inputs[1].value:'',supplier:inputs[2]?inputs[2].value:'',qty:'1',cost:parseFloat(inputs[3]?inputs[3].value:0)||0});});
  snap.reimburse=[];Array.from((document.getElementById('reimburseRows')||{children:[]}).children).forEach(row=>{const inputs=row.querySelectorAll('input');if(inputs[0]&&inputs[0].value)snap.reimburse.push({item:inputs[0].value,partNo:inputs[1]?inputs[1].value:'',supplier:inputs[2]?inputs[2].value:'',qty:'1',cost:parseFloat(inputs[3]?inputs[3].value:0)||0});});
  snap.privateParts=[];Array.from((document.getElementById('privatePartsRows')||{children:[]}).children).forEach(row=>{const inputs=row.querySelectorAll('input');if(inputs[0]&&inputs[0].value)snap.privateParts.push({item:inputs[0].value,source:inputs[1]?inputs[1].value:'',qty:inputs[2]?inputs[2].value:'1',cost:parseFloat(inputs[3]?inputs[3].value:0)||0});});
  snap.jobId=Date.now().toString();snap.savedAt=new Date().toLocaleString('en-AU');snap.filename=`${snap.rego}_${snap.make}_${snap.model}.pdf`.replace(/\s+/g,'_');
  return snap;
}

function saveJobSnapshot(snap,invoiceTotal){snap.invoiceTotal=invoiceTotal;try{let jobs=JSON.parse(localStorage.getItem('jw_jobs')||'[]');jobs.unshift(snap);if(jobs.length>500)jobs=jobs.slice(0,500);localStorage.setItem('jw_jobs',JSON.stringify(jobs));}catch(e){console.error('Snapshot save failed:',e);}}
function getJobs(){try{return JSON.parse(localStorage.getItem('jw_jobs')||'[]');}catch(e){return[];}}
function deleteJob(jobId){if(!confirm('Delete this job? This cannot be undone.'))return;let jobs=getJobs().filter(j=>j.jobId!==jobId);localStorage.setItem('jw_jobs',JSON.stringify(jobs));toast('Job deleted');renderHistory();}

// ═══════════════════════════════════════════════════════════
//  RESTORE JOB
// ═══════════════════════════════════════════════════════════
function restoreJob(jobId){
  const snap=getJobs().find(j=>j.jobId===jobId);if(!snap){toast('Job not found.');return;}
  closeHistory();
  document.getElementById('customerType').value=snap.customerType||'carguysinspection';document.getElementById('reportType').value=snap.reportType||'full';document.getElementById('rego').value=snap.rego||'';document.getElementById('jobDate').value=snap.date||'';document.getElementById('vehicleMake').value=snap.make||'';document.getElementById('vehicleModel').value=snap.model||'';document.getElementById('custName').value=snap.custName||'';document.getElementById('custMobile').value=snap.custMobile||'';document.getElementById('custEmail').value=snap.custEmail||'';document.getElementById('odometer').value=snap.odometer||'';document.getElementById('notesInput').value=snap.notes||'';onCustomerTypeChange();
  const repairOnly=snap.reportType==='repair',isSafety=snap.reportType==='safety'||snap.reportType==='safety_repair';
  ['exteriorCard','bonnetCard','wheelsCard'].forEach(id=>{document.getElementById(id).style.display=repairOnly?'none':'block';});
  document.getElementById('repairFindingsCard').style.display=repairOnly?'block':'none';document.getElementById('chassisCard').style.display=(repairOnly||isSafety)?'none':'block';
  ['findingsCard','faultCard','additionalCard','reimburseCard','deductCard','stockCard','privatePartsCard'].forEach(id=>{document.getElementById(id).style.display='none';});
  if(snap.exterior){buildExteriorUI({lights:{},wipers:{},seatbelts:{},doors:{},windows:{},ac:{},dtc:{}});EXTERIOR_ITEMS.forEach(item=>{const saved=snap.exterior[item.key];if(!saved)return;const s=document.getElementById(`ext_${item.key}_status`),n=document.getElementById(`ext_${item.key}_note`);if(s)s.value=saved.status||'unknown';if(n)n.value=saved.note||'';});}
  if(snap.bonnet){buildBonnetUI({belts:snap.bonnet.belts,hoses:snap.bonnet.hoses,battery:null,coolant:null,brakefluid:snap.bonnet.brakefluid,powersteering:snap.bonnet.powersteering,psNA:false,levelsNote:snap.bonnetLevelsNote||''});BONNET_ITEMS.forEach(item=>{const saved=snap.bonnet[item.key];if(!saved)return;const s=document.getElementById(`bon_${item.key}_status`),n=document.getElementById(`bon_${item.key}_note`);if(s)s.value=saved.status||'unknown';if(n)n.value=saved.note||'';});const levEl=document.getElementById('bonnetLevelsNoteText');if(levEl&&snap.bonnetLevelsNote){levEl.value=snap.bonnetLevelsNote;document.getElementById('bonnetLevelsNote').style.display='block';}}
  if(snap.wheels){buildWheelsUI({lf:{},rf:{},lr:{},rr:{},spare:{}},snap.tyreAdvisory||'');WHEEL_POSITIONS.forEach(pos=>{const saved=snap.wheels[pos.key];if(!saved)return;const tEl=document.getElementById(`w_${pos.key}_tread`),pEl=document.getElementById(`w_${pos.key}_psi`),bEl=document.getElementById(`w_${pos.key}_brakes`),nEl=document.getElementById(`w_${pos.key}_note`);if(tEl)tEl.value=saved.tread||'';if(pEl)pEl.value=saved.pressure||'';if(bEl)bEl.value=saved.brakes||'';if(nEl)nEl.value=saved.note||'';});}
  const chassisTbody=document.getElementById('chassisRows');chassisTbody.innerHTML='';(snap.chassis||[]).forEach(row=>addChassisTableRow(chassisTbody,row.component,row.status,row.notes));
  // Restore findings table
  if(snap.findings&&snap.findings.length>0){showCollapsible('findingsCard','findingsBody','findingsChevron');buildFindingsTableUI('findings',snap.findings);}
  buildFindingsTableUI('repairFindings',snap.repairFindings||[]);
  if(snap.faultRect){showCollapsible('faultCard','faultBody','faultChevron');document.getElementById('faultRect').value=snap.faultRect;}
  document.getElementById('workCompleted').value=snap.workCompleted||'';document.getElementById('quickChecksDesc').value=snap.quickChecksDesc||'';
  if(snap.additionalNotes&&snap.additionalNotes.length>0){showCollapsible('additionalCard','additionalBody','additionalChevron');document.getElementById('additionalNotesRows').innerHTML='';snap.additionalNotes.forEach(n=>addAdditionalNote(n));}
  buildLabourUI(snap.labour||[]);
  if(snap.stock&&snap.stock.length>0){showCollapsible('stockCard','stockBody','stockChevron');document.getElementById('stockRows').innerHTML='';snap.stock.forEach(s=>{addPart('stock');const rows=document.getElementById('stockRows').children,last=rows[rows.length-1],inputs=last.querySelectorAll('input');if(inputs[0])inputs[0].value=s.item;if(inputs[1])inputs[1].value=s.qty;});}
  if(snap.reimburse&&snap.reimburse.length>0){showCollapsible('reimburseCard','reimburseBody','reimburseChevron');document.getElementById('reimburseRows').innerHTML='';snap.reimburse.forEach(r=>{addPart('reimburse');const rows=document.getElementById('reimburseRows').children,last=rows[rows.length-1],inputs=last.querySelectorAll('input');if(inputs[0])inputs[0].value=r.item;if(inputs[1])inputs[1].value=r.partNo;if(inputs[2])inputs[2].value=r.supplier;if(inputs[3])inputs[3].value=r.cost;});}
  if(snap.deduct&&snap.deduct.length>0){showCollapsible('deductCard','deductBody','deductChevron');document.getElementById('deductRows').innerHTML='';snap.deduct.forEach(r=>{addPart('deduct');const rows=document.getElementById('deductRows').children,last=rows[rows.length-1],inputs=last.querySelectorAll('input');if(inputs[0])inputs[0].value=r.item;if(inputs[1])inputs[1].value=r.partNo;if(inputs[2])inputs[2].value=r.supplier;if(inputs[3])inputs[3].value=r.cost;});}
  if(snap.privateParts&&snap.privateParts.length>0){showCollapsible('privatePartsCard','privatePartsBody','privatePartsChevron');document.getElementById('privatePartsRows').innerHTML='';snap.privateParts.forEach(r=>{addPart('private');const rows=document.getElementById('privatePartsRows').children,last=rows[rows.length-1],inputs=last.querySelectorAll('input');if(inputs[0])inputs[0].value=r.item;if(inputs[1])inputs[1].value=r.source;if(inputs[2])inputs[2].value=r.qty;if(inputs[3])inputs[3].value=r.cost;});}
  if(!isCarGuys())showCollapsible('privatePartsCard','privatePartsBody','privatePartsChevron');
  document.getElementById('parseSummary').style.display='none';
  document.getElementById('previewSection').style.display='block';document.getElementById('restoredBanner').style.display='flex';document.getElementById('restoredBannerTitle').textContent=`Loaded: ${snap.rego} · ${snap.make} ${snap.model} · ${snap.date}`;document.getElementById('flagsContainer').innerHTML='';
  window.scrollTo({top:0,behavior:'smooth'});setTimeout(()=>document.getElementById('previewSection').scrollIntoView({behavior:'smooth'}),100);toast(`↩ Loaded: ${snap.rego} ${snap.make} ${snap.model}`);
}

// ═══════════════════════════════════════════════════════════
//  HISTORY
// ═══════════════════════════════════════════════════════════
function showHistory(){renderHistory();document.getElementById('historyModal').style.display='block';}
function closeHistory(){document.getElementById('historyModal').style.display='none';}
function getQuarter(dateStr){if(!dateStr)return 0;const m=dateStr.match(/\d{1,2}\/(\d{1,2})\//);if(!m)return 0;const mo=parseInt(m[1]);if(mo<=3)return 1;if(mo<=6)return 2;if(mo<=9)return 3;return 4;}
function renderHistory(){
  const search=(document.getElementById('historySearch')||{}).value||'',fType=(document.getElementById('historyFilterType')||{}).value||'',fCust=(document.getElementById('historyFilterCust')||{}).value||'',fQ=(document.getElementById('historyFilterQ')||{}).value||'',q=parseInt(fQ)||0;
  const snapJobs=getJobs(),legacy=getHistory().filter(h=>!snapJobs.find(j=>j.rego===h.rego&&j.date===h.date&&Math.abs((j.invoiceTotal||0)-parseFloat(h.total||0))<0.01));
  let all=[...snapJobs.map(j=>({...j,_isSnap:true})),...legacy.map(h=>({rego:h.rego,make:h.make,model:h.model,date:h.date,reportType:h.reportType,customerType:h.customerType,custName:h.custName,invoiceTotal:parseFloat(h.total)||0,savedAt:h.generatedAt,jobId:null,_isSnap:false}))];
  const sl=search.toLowerCase();
  all=all.filter(j=>{if(sl&&!`${j.rego} ${j.make} ${j.model} ${j.custName}`.toLowerCase().includes(sl))return false;if(fType&&j.reportType!==fType)return false;if(fCust&&j.customerType!==fCust)return false;if(q&&getQuarter(j.date)!==q)return false;return true;});
  const totalAmt=all.reduce((s,j)=>s+(parseFloat(j.invoiceTotal)||0),0);
  const totalGst=all.filter(j=>j.customerType!=='cash').reduce((s,j)=>s+(parseFloat(j.invoiceTotal)||0)/11,0);
  document.getElementById('historySummary').innerHTML=`<span>${all.length} job${all.length!==1?'s':''} shown</span><span>Total invoiced: <strong>$${totalAmt.toFixed(2)}</strong></span><span>GST collected: <strong>$${totalGst.toFixed(2)}</strong></span>`;
  if(!all.length){document.getElementById('historyList').innerHTML='<p style="color:#6b7a99;text-align:center;padding:20px;">No jobs found.</p>';return;}
  document.getElementById('historyList').innerHTML=all.map(j=>`<div class="job-card"><div class="job-card-top"><div><div style="font-weight:bold;font-size:14px;color:#1a2744;">${j.rego} · ${j.make||''} ${j.model||''}</div><div style="font-size:12px;color:#6b7a99;margin-top:2px;">${TYPE_LABELS[j.reportType]||j.reportType||''} · ${j.customerType==='carguysinspection'?'The Car Guys':(j.custName||'Private')}</div><div style="font-size:11px;color:#aaa;margin-top:2px;">${j.savedAt||j.date||''}</div></div><div style="text-align:right;"><div style="font-weight:bold;font-size:15px;color:#1a7a3c;">$${parseFloat(j.invoiceTotal||0).toFixed(2)}</div><div style="font-size:11px;color:#aaa;">${j.date||''}</div></div></div><div class="job-card-actions">${j._isSnap&&j.jobId?`<button class="btn-view-job" onclick="restoreJob('${j.jobId}')">↩ View / Edit</button>`:`<span style="font-size:11px;color:#aaa;padding:6px 0;">Legacy record</span>`}${j._isSnap&&j.jobId?`<button class="btn-del-job" onclick="deleteJob('${j.jobId}')">✕ Delete</button>`:''}</div></div>`).join('');
}

// ═══════════════════════════════════════════════════════════
//  SAVE / LOAD
// ═══════════════════════════════════════════════════════════
function autosave(){
  try{const snap=collectCompleteSnapshot();snap.savedAt=new Date().toLocaleTimeString();localStorage.setItem('jw_draft',JSON.stringify(snap));const el=document.getElementById('savedIndicator');if(el)el.textContent='Saved '+snap.savedAt;}catch(e){}
}
function loadSaved(){
  try{const raw=localStorage.getItem('jw_draft');if(!raw){toast('No saved draft found.');return;}const snap=JSON.parse(raw);document.getElementById('customerType').value=snap.customerType||'carguysinspection';document.getElementById('reportType').value=snap.reportType||'full';document.getElementById('rego').value=snap.rego||'';document.getElementById('jobDate').value=snap.date||'';document.getElementById('vehicleMake').value=snap.make||'';document.getElementById('vehicleModel').value=snap.model||'';document.getElementById('custName').value=snap.custName||'';document.getElementById('custMobile').value=snap.custMobile||'';document.getElementById('custEmail').value=snap.custEmail||'';document.getElementById('odometer').value=snap.odometer||'';document.getElementById('notesInput').value=snap.notes||'';onCustomerTypeChange();toast(`↩ Draft restored (${snap.savedAt||''})`);}catch(e){toast('Error loading draft.');}
}
function clearAll(){if(!confirm('Clear all fields and start fresh?'))return;localStorage.removeItem('jw_draft');['notesInput','rego','jobDate','vehicleMake','vehicleModel','custName','custMobile','custEmail','odometer'].forEach(id=>{const el=document.getElementById(id);if(el)el.value='';});document.getElementById('previewSection').style.display='none';document.getElementById('savedIndicator').textContent='';toast('Cleared.');}
document.addEventListener('input',()=>{clearTimeout(window._saveTimer);window._saveTimer=setTimeout(autosave,1500);});
document.getElementById('jobDate').value=todayDate();

// ═══════════════════════════════════════════════════════════
//  CUSTOMER STORAGE
// ═══════════════════════════════════════════════════════════
function getCustomers(){try{return JSON.parse(localStorage.getItem('jw_customers')||'[]');}catch(e){return[];}}
function saveCustomer(name,mobile,email){if(!name)return;let customers=getCustomers();const idx=customers.findIndex(c=>c.name.toLowerCase()===name.toLowerCase());const record={name,mobile,email,lastSeen:new Date().toLocaleDateString('en-AU')};if(idx>=0)customers[idx]=record;else customers.unshift(record);customers=customers.slice(0,100);localStorage.setItem('jw_customers',JSON.stringify(customers));}
function customerAutocomplete(input){const val=input.value.toLowerCase(),box=document.getElementById('custAutocomplete');if(!val||val.length<2){box.style.display='none';return;}const matches=getCustomers().filter(c=>c.name.toLowerCase().startsWith(val));if(!matches.length){box.style.display='none';return;}box.innerHTML=matches.slice(0,5).map(c=>`<div onclick="fillCustomer('${c.name.replace(/'/g,"\\'")}','${(c.mobile||'').replace(/'/g,"\\'")}','${(c.email||'').replace(/'/g,"\\'")}' )" style="padding:10px 14px;cursor:pointer;border-bottom:1px solid #eee;font-size:13px;" onmouseover="this.style.background='#f4f6fa'" onmouseout="this.style.background='white'"><strong>${c.name}</strong><br><span style="color:#6b7a99;font-size:11px;">${c.mobile||''} ${c.email?'· '+c.email:''}</span></div>`).join('');box.style.display='block';}
function fillCustomer(name,mobile,email){document.getElementById('custName').value=name;document.getElementById('custMobile').value=mobile;document.getElementById('custEmail').value=email;document.getElementById('custAutocomplete').style.display='none';toast(`↩ Loaded ${name}`);}
function showCustomers(){const customers=getCustomers(),list=document.getElementById('customersList');if(!customers.length){list.innerHTML='<p style="color:#6b7a99;text-align:center;padding:20px;">No saved customers yet.</p>';}else{list.innerHTML=customers.map(c=>`<div style="display:flex;justify-content:space-between;align-items:center;padding:12px 0;border-bottom:1px solid #eee;"><div><div style="font-weight:bold;font-size:14px;color:#1a2744;">${c.name}</div><div style="font-size:12px;color:#6b7a99;">${c.mobile||'—'} · ${c.email||'—'}</div><div style="font-size:11px;color:#aaa;">Last seen: ${c.lastSeen||'—'}</div></div><div style="display:flex;gap:8px;"><button onclick="fillCustomer('${c.name.replace(/'/g,"\\'")}','${(c.mobile||'').replace(/'/g,"\\'")}','${(c.email||'').replace(/'/g,"\\'")}');closeCustomers();" style="background:#1a2744;color:white;border:none;border-radius:6px;padding:6px 12px;font-size:12px;cursor:pointer;">Use</button><button onclick="deleteCustomer('${c.name.replace(/'/g,"\\'")}');showCustomers();" style="background:none;border:1px solid #c0392b;color:#c0392b;border-radius:6px;padding:6px 10px;font-size:12px;cursor:pointer;">✕</button></div></div>`).join('');}document.getElementById('customersModal').style.display='block';}
function deleteCustomer(name){let customers=getCustomers().filter(c=>c.name!==name);localStorage.setItem('jw_customers',JSON.stringify(customers));toast(`Removed ${name}`);}
function closeCustomers(){document.getElementById('customersModal').style.display='none';}

// ═══════════════════════════════════════════════════════════
//  LEGACY HISTORY
// ═══════════════════════════════════════════════════════════
function getHistory(){try{return JSON.parse(localStorage.getItem('jw_history')||'[]');}catch(e){return[];}}
function saveToHistory(d,total){let history=getHistory();history.unshift({rego:d.rego,make:d.make,model:d.model,date:d.date,reportType:d.reportType,customerType:d.customerType,custName:d.custName||'',total:total,generatedAt:new Date().toLocaleString('en-AU')});history=history.slice(0,200);localStorage.setItem('jw_history',JSON.stringify(history));}

// ═══════════════════════════════════════════════════════════
//  BACKUP & RESTORE
// ═══════════════════════════════════════════════════════════
function exportBackup(){const backup={exportedAt:new Date().toISOString(),version:2,customers:getCustomers(),history:getHistory(),jobs:getJobs(),draft:JSON.parse(localStorage.getItem('jw_draft')||'null')};const blob=new Blob([JSON.stringify(backup,null,2)],{type:'application/json'});const url=URL.createObjectURL(blob);const a=document.createElement('a');a.href=url;a.download=`JW_Reports_Backup_${new Date().toLocaleDateString('en-AU').replace(/\//g,'-')}.json`;a.click();URL.revokeObjectURL(url);toast('✓ Backup downloaded');}
function importBackup(event){const file=event.target.files[0];if(!file)return;const reader=new FileReader();reader.onload=function(e){try{const backup=JSON.parse(e.target.result);if(!backup.version)throw new Error('Invalid backup');if(backup.customers)localStorage.setItem('jw_customers',JSON.stringify(backup.customers));if(backup.history)localStorage.setItem('jw_history',JSON.stringify(backup.history));if(backup.jobs)localStorage.setItem('jw_jobs',JSON.stringify(backup.jobs));if(backup.draft)localStorage.setItem('jw_draft',JSON.stringify(backup.draft));toast(`✓ Restored: ${(backup.customers||[]).length} customers, ${(backup.jobs||[]).length} jobs`);}catch(err){toast('Error reading backup file.');}event.target.value='';};reader.readAsText(file);}

// ── HAMBURGER MENU ──
function toggleMenu(){const menu=document.getElementById('dropdownMenu');menu.style.display=menu.style.display==='none'?'block':'none';}
document.addEventListener('click',function(e){if(!e.target.closest('#dropdownMenu')&&!e.target.closest('#menuBtn'))document.getElementById('dropdownMenu').style.display='none';if(!e.target.closest('#custAutocomplete')&&e.target.id!=='custName'){const box=document.getElementById('custAutocomplete');if(box)box.style.display='none';}});
document.getElementById('historyModal').addEventListener('click',function(e){if(e.target===this)closeHistory();});
document.getElementById('customersModal').addEventListener('click',function(e){if(e.target===this)closeCustomers();});
</script>
</body>
</html>
