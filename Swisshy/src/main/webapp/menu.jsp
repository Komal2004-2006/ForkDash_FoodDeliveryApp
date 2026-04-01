<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.tap.model.MenuItem" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.html");
        return;
    }
    String restaurantName = (String) request.getAttribute("restaurantName");
    List<MenuItem> menuList = (List<MenuItem>) request.getAttribute("menuList");
    if (menuList == null) menuList = new java.util.ArrayList<>();
    if (restaurantName == null) restaurantName = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ForkDash — <%= restaurantName %> Menu</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --bg: #0d0d0d; --surface: #161616; --card: #1c1c1c;
      --border: #2a2a2a; --accent: #ff5c2b;
      --text: #f0ede8; --muted: #888; --nav-h: 70px;
    }
    body { font-family: 'DM Sans', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }
    nav {
      position: fixed; top: 0; left: 0; right: 0; z-index: 100;
      height: var(--nav-h); display: flex; align-items: center; justify-content: space-between;
      padding: 0 32px; background: rgba(13,13,13,0.9); backdrop-filter: blur(18px);
      border-bottom: 1px solid var(--border);
    }
    .nav-logo { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.55rem; color: var(--text); text-decoration: none; }
    .nav-logo span { color: var(--accent); }
    .nav-links { display: flex; align-items: center; gap: 6px; }
    .nav-links a { display: flex; align-items: center; gap: 7px; padding: 8px 16px; border-radius: 50px; color: var(--muted); text-decoration: none; font-size: 0.88rem; font-weight: 500; transition: background 0.2s, color 0.2s; }
    .nav-links a:hover { background: var(--surface); color: var(--text); }
    .page { padding-top: calc(var(--nav-h) + 40px); padding-bottom: 60px; max-width: 900px; margin: 0 auto; padding-left: 32px; padding-right: 32px; }
    .back-link { display: inline-flex; align-items: center; gap: 6px; color: var(--muted); font-size: 0.85rem; text-decoration: none; margin-bottom: 24px; transition: color 0.2s; }
    .back-link:hover { color: var(--accent); }
    .page-heading { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 2rem; margin-bottom: 4px; }
    .page-sub { color: var(--muted); font-size: 0.92rem; margin-bottom: 40px; }
    .menu-grid { display: flex; flex-direction: column; gap: 16px; }
    .menu-item { background: var(--card); border: 1px solid var(--border); border-radius: 16px; padding: 20px 24px; display: flex; align-items: center; justify-content: space-between; gap: 20px; transition: border-color 0.2s, transform 0.2s; animation: fadeUp 0.4s ease both; }
    .menu-item:hover { border-color: rgba(255,92,43,0.3); transform: translateX(4px); }
    @keyframes fadeUp { from { opacity:0; transform:translateY(16px); } to { opacity:1; transform:translateY(0); } }
    .item-info { flex: 1; }
    .item-name { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1rem; margin-bottom: 4px; }
    .item-desc { font-size: 0.82rem; color: var(--muted); line-height: 1.5; margin-bottom: 8px; }
    .item-category { display: inline-block; font-size: 0.72rem; font-weight: 600; color: var(--accent); background: rgba(255,92,43,0.1); border: 1px solid rgba(255,92,43,0.2); padding: 3px 10px; border-radius: 20px; }
    .item-right { text-align: right; flex-shrink: 0; }
    .item-price { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.2rem; color: var(--text); margin-bottom: 10px; }
    .item-price span { color: var(--accent); }
    .add-btn { background: var(--accent); color: #fff; border: none; padding: 8px 18px; border-radius: 10px; font-family: 'Syne', sans-serif; font-size: 0.82rem; font-weight: 700; cursor: pointer; transition: background 0.2s; }
    .add-btn:hover { background: #e04d22; }
    .empty { text-align: center; padding: 80px 20px; color: var(--muted); }
    .empty h2 { font-family: 'Syne', sans-serif; font-size: 1.4rem; color: var(--text); margin-bottom: 10px; }
  </style>
</head>
<body>
<nav>
  <a class="nav-logo" href="index.jsp">Fork<span>Dash</span></a>
  <div class="nav-links">
    <a href="restaurant">Restaurants</a>
   <a href="cart">&#128722; Cart</a>  <!-- ✅ CORRECT -->
    <a href="logout">Logout</a>
  </div>
</nav>
<div class="page">
  <a href="restaurant" class="back-link">&#8592; Back to Restaurants</a>
  <h1 class="page-heading"><%= restaurantName %></h1>
  <p class="page-sub">Browse the full menu and add items to your cart</p>
  <div class="menu-grid">
  <% if (menuList.isEmpty()) { %>
    <div class="empty">
      <h2>No menu items yet</h2>
      <p>Items will appear here once added by the admin.</p>
    </div>
  <% } else {
       for (MenuItem item : menuList) { %>
    <div class="menu-item">
      <div class="item-info">
        <div class="item-name"><%= item.getItemName() %></div>
        <div class="item-desc"><%= item.getDescription() %></div>
        <span class="item-category"><%= item.getCategory() %></span>
      </div>
      <div class="item-right">
        <div class="item-price">&#8377;<span><%= String.format("%.2f", item.getPrice()) %></span></div>
        <form method="post" action="cart">
          <input type="hidden" name="action"     value="add"/>
          <input type="hidden" name="itemId"     value="<%= item.getId() %>"/>
          <input type="hidden" name="itemName"   value="<%= item.getItemName() %>"/>
          <input type="hidden" name="itemPrice"  value="<%= item.getPrice() %>"/>
          <input type="hidden" name="restaurant" value="<%= restaurantName %>"/>
          <button type="submit" class="add-btn">+ Add to Cart</button>
        </form>
      </div>
    </div>
  <% } } %>
  </div>
</div>
</body>
</html>
