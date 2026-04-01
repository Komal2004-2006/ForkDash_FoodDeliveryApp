<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.html"); return;
    }
    String role = (String) s.getAttribute("role");
    if (!"restaurant_admin".equals(role)) {
        response.sendRedirect("login.html"); return;
    }
    String adminName = (String) s.getAttribute("userName");
    Map<String, String> restaurant = (Map<String, String>) request.getAttribute("restaurant");
    List<Map<String, String>> menuItems = (List<Map<String, String>>) request.getAttribute("menuItems");
    List<Map<String, String>> orders    = (List<Map<String, String>>) request.getAttribute("orders");
    String restaurantName = (String) request.getAttribute("restaurantName");
    if (restaurant == null) restaurant = new HashMap<>();
    if (menuItems  == null) menuItems  = new ArrayList<>();
    if (orders     == null) orders     = new ArrayList<>();

    // Count orders by status
    int placedCount = 0, preparingCount = 0, readyCount = 0, deliveredCount = 0;
    for (Map<String,String> o : orders) {
        String st = o.get("status");
        if ("Placed".equals(st))     placedCount++;
        else if ("Preparing".equals(st)) preparingCount++;
        else if ("Ready".equals(st))     readyCount++;
        else if ("Delivered".equals(st)) deliveredCount++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ForkDash — Restaurant Dashboard</title>
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
    .nl.active{background:rgba(255,92,43,.15);color:var(--accent)}

    .page{max-width:1100px;margin:0 auto;padding:calc(var(--nav-h)+40px) 40px 80px}
    .eye{font-size:.71rem;font-weight:600;letter-spacing:2.5px;text-transform:uppercase;color:var(--accent);margin-bottom:8px}
    .ptitle{font-family:'Syne',sans-serif;font-weight:800;font-size:2rem;letter-spacing:-1px;margin-bottom:32px}

    /* TABS */
    .tabs{display:flex;gap:4px;margin-bottom:32px;background:var(--surface);padding:6px;border-radius:14px;width:fit-content}
    .tab{padding:9px 22px;border-radius:10px;font-family:'Syne',sans-serif;font-weight:700;font-size:.84rem;cursor:pointer;color:var(--muted);border:none;background:transparent;transition:all .2s}
    .tab.on{background:var(--card);color:var(--text);border:1px solid var(--border)}

    .tab-content{display:none}
    .tab-content.on{display:block}

    /* STATS */
    .stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:32px}
    .stat{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:20px;text-align:center}
    .stat-num{font-family:'Syne',sans-serif;font-weight:800;font-size:2rem;color:var(--accent)}
    .stat-label{font-size:.78rem;color:var(--muted);margin-top:4px}

    /* RESTAURANT DETAILS */
    .detail-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}
    .detail-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:20px}
    .detail-label{font-size:.75rem;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:1px;margin-bottom:6px}
    .detail-value{font-family:'Syne',sans-serif;font-weight:700;font-size:1rem}

    /* ORDERS */
    .orders-list{display:flex;flex-direction:column;gap:14px}
    .order-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:20px 24px;animation:fadeUp .3s ease both}
    @keyframes fadeUp{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}
    .order-top{display:flex;align-items:center;justify-content:space-between;margin-bottom:12px}
    .order-id{font-family:'Syne',sans-serif;font-weight:800;font-size:1rem}
    .order-time{font-size:.76rem;color:var(--muted)}
    .order-info{display:flex;gap:24px;margin-bottom:14px;flex-wrap:wrap}
    .order-info span{font-size:.84rem;color:var(--muted)}
    .order-info strong{color:var(--text)}
    .status-badge{padding:4px 14px;border-radius:50px;font-size:.75rem;font-weight:700}
    .status-Placed{background:rgba(59,130,246,.15);color:#3b82f6}
    .status-Preparing{background:rgba(245,158,11,.15);color:#f59e0b}
    .status-Ready{background:rgba(34,197,94,.15);color:#22c55e}
    .status-Delivered{background:rgba(107,114,128,.15);color:#6b7280}
    .status-actions{display:flex;gap:8px;flex-wrap:wrap}
    .status-btn{padding:7px 16px;border-radius:8px;font-family:'Syne',sans-serif;font-size:.78rem;font-weight:700;cursor:pointer;border:none;transition:all .15s}
    .btn-preparing{background:rgba(245,158,11,.15);color:#f59e0b;border:1px solid rgba(245,158,11,.3)}
    .btn-preparing:hover{background:rgba(245,158,11,.3)}
    .btn-ready{background:rgba(34,197,94,.15);color:#22c55e;border:1px solid rgba(34,197,94,.3)}
    .btn-ready:hover{background:rgba(34,197,94,.3)}
    .btn-delivered{background:rgba(107,114,128,.15);color:#9ca3af;border:1px solid rgba(107,114,128,.3)}
    .btn-delivered:hover{background:rgba(107,114,128,.3)}

    /* MENU */
    .menu-grid{display:flex;flex-direction:column;gap:12px}
    .menu-row{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:16px 20px;display:flex;align-items:center;justify-content:space-between;gap:16px}
    .menu-name{font-family:'Syne',sans-serif;font-weight:700;font-size:.95rem}
    .menu-desc{font-size:.78rem;color:var(--muted);margin-top:2px}
    .menu-cat{display:inline-block;font-size:.68rem;font-weight:600;color:var(--accent);background:rgba(255,92,43,.1);border:1px solid rgba(255,92,43,.2);padding:2px 9px;border-radius:20px;margin-top:5px}
    .menu-price{font-family:'Syne',sans-serif;font-weight:800;font-size:1rem;color:var(--accent);white-space:nowrap}

    /* ADD MENU FORM */
    .form-card{background:var(--card);border:1px solid var(--border);border-radius:20px;padding:28px;max-width:600px}
    .form-title{font-family:'Syne',sans-serif;font-weight:800;font-size:1.1rem;margin-bottom:22px}
    .form-row{display:grid;grid-template-columns:1fr 1fr;gap:16px}
    label{display:block;font-size:.78rem;font-weight:600;color:var(--muted);margin-bottom:6px;text-transform:uppercase;letter-spacing:1px}
    input,select,textarea{width:100%;background:var(--surface);border:1px solid var(--border);border-radius:10px;padding:11px 14px;color:var(--text);font-family:'DM Sans',sans-serif;font-size:.9rem;outline:none;transition:border-color .2s;margin-bottom:16px}
    input:focus,select:focus,textarea:focus{border-color:var(--accent)}
    select option{background:var(--card)}
    .submit-btn{background:var(--accent);color:#fff;border:none;padding:12px 28px;border-radius:12px;font-family:'Syne',sans-serif;font-weight:700;font-size:.9rem;cursor:pointer;transition:all .2s}
    .submit-btn:hover{background:#e04d22}

    .empty{text-align:center;padding:50px;color:var(--muted)}
    .empty h3{font-family:'Syne',sans-serif;font-size:1.1rem;color:var(--text);margin-bottom:8px}

    @media(max-width:768px){
      .stats{grid-template-columns:repeat(2,1fr)}
      .detail-grid{grid-template-columns:1fr}
      .form-row{grid-template-columns:1fr}
      .page{padding:calc(var(--nav-h)+20px) 16px 60px}
      nav{padding:0 18px}
    }
  </style>
</head>
<body>
<nav>
  <a class="logo" href="index.jsp">Fork<span>Dash</span></a>
  <div class="nav-r">
    <span style="font-size:.84rem;color:var(--muted)">👋 <%= adminName %></span>
    <a href="logout" class="nl" style="color:#ff5555">Logout</a>
  </div>
</nav>

<div class="page">
  <div class="eye">Restaurant Admin</div>
  <h1 class="ptitle"><%= restaurantName != null ? restaurantName : "Your Restaurant" %> Dashboard</h1>

  <!-- STATS -->
  <div class="stats">
    <div class="stat"><div class="stat-num"><%= placedCount %></div><div class="stat-label">New Orders</div></div>
    <div class="stat"><div class="stat-num"><%= preparingCount %></div><div class="stat-label">Preparing</div></div>
    <div class="stat"><div class="stat-num"><%= readyCount %></div><div class="stat-label">Ready</div></div>
    <div class="stat"><div class="stat-num"><%= deliveredCount %></div><div class="stat-label">Delivered</div></div>
  </div>

  <!-- TABS -->
  <div class="tabs">
    <button class="tab on" onclick="showTab('orders', this)">📋 Orders (<%= orders.size() %>)</button>
    <button class="tab" onclick="showTab('menu', this)">🍽️ Menu (<%= menuItems.size() %>)</button>
    <button class="tab" onclick="showTab('addmenu', this)">➕ Add Item</button>
    <button class="tab" onclick="showTab('details', this)">🏪 Restaurant</button>
  </div>

  <!-- TAB: ORDERS -->
  <div id="tab-orders" class="tab-content on">
    <% if (orders.isEmpty()) { %>
    <div class="empty"><h3>No orders yet</h3><p>Orders will appear here when customers place them.</p></div>
    <% } else { %>
    <div class="orders-list">
      <% for (Map<String,String> order : orders) { %>
      <div class="order-card">
        <div class="order-top">
          <div>
            <div class="order-id">Order #<%= order.get("id") %></div>
            <div class="order-time"><%= order.get("created_at") %></div>
          </div>
          <span class="status-badge status-<%= order.get("status") %>"><%= order.get("status") %></span>
        </div>
        <div class="order-info">
          <span>👤 <strong><%= order.get("user_name") %></strong></span>
          <span>📞 <strong><%= order.get("phone") %></strong></span>
          <span>📍 <strong><%= order.get("address") %></strong></span>
          <span>💰 <strong>₹<%= String.format("%.0f", Double.parseDouble(order.get("total"))) %></strong></span>
        </div>
        <div class="status-actions">
          <% String st = order.get("status"); %>
          <% if ("Placed".equals(st)) { %>
          <form method="post" action="restaurantAdmin" style="display:inline">
            <input type="hidden" name="action"   value="updateStatus"/>
            <input type="hidden" name="orderId"  value="<%= order.get("id") %>"/>
            <input type="hidden" name="status"   value="Preparing"/>
            <button type="submit" class="status-btn btn-preparing">🔥 Start Preparing</button>
          </form>
          <% } else if ("Preparing".equals(st)) { %>
          <form method="post" action="restaurantAdmin" style="display:inline">
            <input type="hidden" name="action"   value="updateStatus"/>
            <input type="hidden" name="orderId"  value="<%= order.get("id") %>"/>
            <input type="hidden" name="status"   value="Ready"/>
            <button type="submit" class="status-btn btn-ready">✅ Mark Ready</button>
          </form>
          <% } else if ("Ready".equals(st)) { %>
          <span style="font-size:.82rem;color:#22c55e;font-weight:600">✅ Ready for pickup</span>
          <% } else { %>
          <span style="font-size:.82rem;color:var(--muted)">✔ Completed</span>
          <% } %>
        </div>
      </div>
      <% } %>
    </div>
    <% } %>
  </div>

  <!-- TAB: MENU -->
  <div id="tab-menu" class="tab-content">
    <% if (menuItems.isEmpty()) { %>
    <div class="empty"><h3>No menu items yet</h3><p>Add your first item using the ➕ Add Item tab.</p></div>
    <% } else { %>
    <div class="menu-grid">
      <% for (Map<String,String> item : menuItems) { %>
      <div class="menu-row">
        <div>
          <div class="menu-name"><%= item.get("item_name") %></div>
          <div class="menu-desc"><%= item.get("description") %></div>
          <span class="menu-cat"><%= item.get("category") %></span>
        </div>
        <div class="menu-price">₹<%= String.format("%.0f", Double.parseDouble(item.get("price"))) %></div>
      </div>
      <% } %>
    </div>
    <% } %>
  </div>

  <!-- TAB: ADD MENU ITEM -->
  <div id="tab-addmenu" class="tab-content">
    <div class="form-card">
      <div class="form-title">➕ Add New Menu Item</div>
      <form method="post" action="menu">
        <input type="hidden" name="restaurant" value="<%= restaurantName != null ? restaurantName : "" %>"/>

        <label>Item Name</label>
        <input type="text" name="item_name" placeholder="e.g. Chicken Biryani" required/>

        <label>Description</label>
        <input type="text" name="description" placeholder="Brief description of the item"/>

        <div class="form-row">
          <div>
            <label>Price (₹)</label>
            <input type="number" name="price" placeholder="299" step="0.01" required/>
          </div>
          <div>
            <label>Category</label>
            <select name="category">
              <option>Starters</option>
              <option>Main Course</option>
              <option>Biryani</option>
              <option>Pizza</option>
              <option>Burgers</option>
              <option>Drinks</option>
              <option>Desserts</option>
              <option>Breads</option>
              <option>Sides</option>
            </select>
          </div>
        </div>

        <button type="submit" class="submit-btn">Add to Menu →</button>
      </form>
    </div>
  </div>

  <!-- TAB: RESTAURANT DETAILS -->
  <div id="tab-details" class="tab-content">
    <% if (restaurant.isEmpty()) { %>
    <div class="empty">
      <h3>No restaurant found</h3>
      <p>Your account is not linked to any restaurant yet.</p>
      <a href="addRestaurant.html" style="color:var(--accent);font-weight:600">+ Add Your Restaurant</a>
    </div>
    <% } else { %>
    <div class="detail-grid">
      <div class="detail-card"><div class="detail-label">Restaurant Name</div><div class="detail-value"><%= restaurant.get("name") %></div></div>
      <div class="detail-card"><div class="detail-label">Cuisine</div><div class="detail-value"><%= restaurant.get("cuisine") %></div></div>
      <div class="detail-card"><div class="detail-label">Location</div><div class="detail-value"><%= restaurant.get("location") %></div></div>
      <div class="detail-card"><div class="detail-label">Rating</div><div class="detail-value">⭐ <%= restaurant.get("rating") %></div></div>
      <div class="detail-card"><div class="detail-label">Estimated Time</div><div class="detail-value">🕐 <%= restaurant.get("eta") %></div></div>
      <div class="detail-card"><div class="detail-label">Current Offer</div><div class="detail-value"><%= restaurant.get("offer").isEmpty() ? "No offer" : restaurant.get("offer") %></div></div>
      <div class="detail-card" style="grid-column:1/-1"><div class="detail-label">Description</div><div class="detail-value" style="font-weight:400;font-size:.9rem;line-height:1.6"><%= restaurant.get("description").isEmpty() ? "No description added" : restaurant.get("description") %></div></div>
    </div>
    <div style="margin-top:16px">
      <a href="addRestaurant.html" style="color:var(--accent);font-size:.85rem;font-weight:600">+ Add Another Restaurant</a>
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
