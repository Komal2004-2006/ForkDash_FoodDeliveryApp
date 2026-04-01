<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.html"); return;
    }
    String role = (String) s.getAttribute("role");
    if (!"delivery_agent".equals(role)) {
        response.sendRedirect("login.html"); return;
    }
    String agentName = (String) s.getAttribute("userName");
    List<Map<String,String>> availableOrders = (List<Map<String,String>>) request.getAttribute("availableOrders");
    List<Map<String,String>> myDeliveries    = (List<Map<String,String>>) request.getAttribute("myDeliveries");
    List<Map<String,String>> history         = (List<Map<String,String>>) request.getAttribute("history");
    if (availableOrders == null) availableOrders = new ArrayList<>();
    if (myDeliveries    == null) myDeliveries    = new ArrayList<>();
    if (history         == null) history         = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ForkDash — Delivery Dashboard</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
  <style>
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    :root{--bg:#080808;--surface:#0f0f0f;--card:#161616;--border:#222;--accent:#ff5c2b;--text:#f0ede8;--muted:#666;--nav-h:72px}
    body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}
    nav{position:fixed;top:0;left:0;right:0;z-index:100;height:var(--nav-h);display:flex;align-items:center;justify-content:space-between;padding:0 40px;background:rgba(8,8,8,.92);backdrop-filter:blur(20px);border-bottom:1px solid rgba(255,255,255,.05)}
    .logo{font-family:'Syne',sans-serif;font-weight:800;font-size:1.5rem;color:var(--text);text-decoration:none}
    .logo span{color:var(--accent)}
    .nav-r{display:flex;align-items:center;gap:8px}
    .nl{padding:7px 16px;border-radius:50px;color:var(--muted);text-decoration:none;font-size:.84rem;font-weight:500;transition:all .2s}
    .nl:hover{background:rgba(255,255,255,.06);color:var(--text)}

    .page{max-width:1000px;margin:0 auto;padding:calc(var(--nav-h)+40px) 40px 80px}
    .eye{font-size:.71rem;font-weight:600;letter-spacing:2.5px;text-transform:uppercase;color:var(--accent);margin-bottom:8px}
    .ptitle{font-family:'Syne',sans-serif;font-weight:800;font-size:2rem;letter-spacing:-1px;margin-bottom:32px}

    /* STATS */
    .stats{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:32px}
    .stat{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:20px;text-align:center}
    .stat-num{font-family:'Syne',sans-serif;font-weight:800;font-size:2rem;color:var(--accent)}
    .stat-label{font-size:.78rem;color:var(--muted);margin-top:4px}

    /* TABS */
    .tabs{display:flex;gap:4px;margin-bottom:32px;background:var(--surface);padding:6px;border-radius:14px;width:fit-content}
    .tab{padding:9px 22px;border-radius:10px;font-family:'Syne',sans-serif;font-weight:700;font-size:.84rem;cursor:pointer;color:var(--muted);border:none;background:transparent;transition:all .2s}
    .tab.on{background:var(--card);color:var(--text);border:1px solid var(--border)}
    .tab-content{display:none}
    .tab-content.on{display:block}

    /* ORDER CARDS */
    .orders-list{display:flex;flex-direction:column;gap:14px}
    .order-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:20px 24px;animation:fadeUp .3s ease both}
    @keyframes fadeUp{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}
    .order-top{display:flex;align-items:center;justify-content:space-between;margin-bottom:12px}
    .order-id{font-family:'Syne',sans-serif;font-weight:800;font-size:1rem}
    .order-time{font-size:.76rem;color:var(--muted);margin-top:2px}
    .order-info{display:flex;gap:20px;margin-bottom:14px;flex-wrap:wrap}
    .order-info span{font-size:.84rem;color:var(--muted)}
    .order-info strong{color:var(--text)}
    .status-badge{padding:4px 14px;border-radius:50px;font-size:.75rem;font-weight:700}
    .status-Ready{background:rgba(34,197,94,.15);color:#22c55e}
    .status-Out{background:rgba(245,158,11,.15);color:#f59e0b}
    .status-Delivered{background:rgba(107,114,128,.15);color:#9ca3af}

    .accept-btn{background:var(--accent);color:#fff;border:none;padding:9px 20px;border-radius:10px;font-family:'Syne',sans-serif;font-size:.82rem;font-weight:700;cursor:pointer;transition:all .2s;box-shadow:0 4px 14px rgba(255,92,43,.3)}
    .accept-btn:hover{background:#e04d22;transform:translateY(-1px)}
    .deliver-btn{background:rgba(34,197,94,.15);color:#22c55e;border:1px solid rgba(34,197,94,.3);padding:9px 20px;border-radius:10px;font-family:'Syne',sans-serif;font-size:.82rem;font-weight:700;cursor:pointer;transition:all .2s}
    .deliver-btn:hover{background:rgba(34,197,94,.3)}

    .empty{text-align:center;padding:50px;color:var(--muted)}
    .empty h3{font-family:'Syne',sans-serif;font-size:1.1rem;color:var(--text);margin-bottom:8px}

    @media(max-width:768px){
      .stats{grid-template-columns:repeat(2,1fr)}
      .page{padding:calc(var(--nav-h)+20px) 16px 60px}
      nav{padding:0 18px}
    }
  </style>
</head>
<body>
<nav>
  <a class="logo" href="index.jsp">Fork<span>Dash</span></a>
  <div class="nav-r">
    <span style="font-size:.84rem;color:var(--muted)">🚴 <%= agentName %></span>
    <a href="logout" class="nl" style="color:#ff5555">Logout</a>
  </div>
</nav>

<div class="page">
  <div class="eye">Delivery Agent</div>
  <h1 class="ptitle">Delivery Dashboard</h1>

  <!-- STATS -->
  <div class="stats">
    <div class="stat"><div class="stat-num"><%= availableOrders.size() %></div><div class="stat-label">Available Pickups</div></div>
    <div class="stat"><div class="stat-num"><%= myDeliveries.size() %></div><div class="stat-label">My Active Deliveries</div></div>
    <div class="stat"><div class="stat-num"><%= history.size() %></div><div class="stat-label">Completed</div></div>
  </div>

  <!-- TABS -->
  <div class="tabs">
    <button class="tab on" onclick="showTab('available', this)">📦 Available (<%= availableOrders.size() %>)</button>
    <button class="tab"    onclick="showTab('active', this)">🚴 My Deliveries (<%= myDeliveries.size() %>)</button>
    <button class="tab"    onclick="showTab('history', this)">✅ History (<%= history.size() %>)</button>
  </div>

  <!-- TAB: AVAILABLE ORDERS -->
  <div id="tab-available" class="tab-content on">
    <% if (availableOrders.isEmpty()) { %>
    <div class="empty"><h3>No orders available</h3><p>Orders marked as Ready by restaurants will appear here.</p></div>
    <% } else { %>
    <div class="orders-list">
      <% for (Map<String,String> order : availableOrders) { %>
      <div class="order-card">
        <div class="order-top">
          <div>
            <div class="order-id">Order #<%= order.get("id") %></div>
            <div class="order-time"><%= order.get("created_at") %></div>
          </div>
          <span class="status-badge status-Ready">Ready for Pickup</span>
        </div>
        <div class="order-info">
          <span>🏪 <strong><%= order.get("restaurant_name") %></strong></span>
          <span>👤 <strong><%= order.get("user_name") %></strong></span>
          <span>📞 <strong><%= order.get("phone") %></strong></span>
          <span>📍 <strong><%= order.get("address") %></strong></span>
          <span>💰 <strong>₹<%= String.format("%.0f", Double.parseDouble(order.get("total"))) %></strong></span>
        </div>
        <form method="post" action="delivery">
          <input type="hidden" name="action"  value="accept"/>
          <input type="hidden" name="orderId" value="<%= order.get("id") %>"/>
          <button type="submit" class="accept-btn">🚴 Accept Delivery</button>
        </form>
      </div>
      <% } %>
    </div>
    <% } %>
  </div>

  <!-- TAB: MY ACTIVE DELIVERIES -->
  <div id="tab-active" class="tab-content">
    <% if (myDeliveries.isEmpty()) { %>
    <div class="empty"><h3>No active deliveries</h3><p>Accept an order from the Available tab to start delivering.</p></div>
    <% } else { %>
    <div class="orders-list">
      <% for (Map<String,String> order : myDeliveries) { %>
      <div class="order-card">
        <div class="order-top">
          <div>
            <div class="order-id">Order #<%= order.get("id") %></div>
            <div class="order-time"><%= order.get("created_at") %></div>
          </div>
          <span class="status-badge status-Out">Out for Delivery</span>
        </div>
        <div class="order-info">
          <span>🏪 <strong><%= order.get("restaurant_name") %></strong></span>
          <span>👤 <strong><%= order.get("user_name") %></strong></span>
          <span>📞 <strong><%= order.get("phone") %></strong></span>
          <span>📍 <strong><%= order.get("address") %></strong></span>
          <span>💰 <strong>₹<%= String.format("%.0f", Double.parseDouble(order.get("total"))) %></strong></span>
        </div>
        <form method="post" action="delivery">
          <input type="hidden" name="action"  value="deliver"/>
          <input type="hidden" name="orderId" value="<%= order.get("id") %>"/>
          <button type="submit" class="deliver-btn">✅ Mark as Delivered</button>
        </form>
      </div>
      <% } %>
    </div>
    <% } %>
  </div>

  <!-- TAB: HISTORY -->
  <div id="tab-history" class="tab-content">
    <% if (history.isEmpty()) { %>
    <div class="empty"><h3>No delivery history yet</h3><p>Completed deliveries will appear here.</p></div>
    <% } else { %>
    <div class="orders-list">
      <% for (Map<String,String> order : history) { %>
      <div class="order-card">
        <div class="order-top">
          <div>
            <div class="order-id">Order #<%= order.get("id") %></div>
            <div class="order-time"><%= order.get("created_at") %></div>
          </div>
          <span class="status-badge status-Delivered">Delivered ✓</span>
        </div>
        <div class="order-info">
          <span>🏪 <strong><%= order.get("restaurant_name") %></strong></span>
          <span>👤 <strong><%= order.get("user_name") %></strong></span>
          <span>📍 <strong><%= order.get("address") %></strong></span>
          <span>💰 <strong>₹<%= String.format("%.0f", Double.parseDouble(order.get("total"))) %></strong></span>
        </div>
      </div>
      <% } %>
    </div>
    <% } %>
  </div>

</div>

<script>
function showTab(name, btn) {
  document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('on'));
  document.querySelectorAll('.tab').forEach(t => t.classList.remove('on'));
  document.getElementById('tab-' + name).classList.add('on');
  btn.classList.add('on');
}
</script>
</body>
</html>
