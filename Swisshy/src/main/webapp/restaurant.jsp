<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("loggedUser") == null) {
        response.sendRedirect("login.html");
        return;
    }
    String userName = (String) s.getAttribute("userName");
    String role = (String) s.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ForkDash — Restaurants</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
  <style>
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    :root{--bg:#080808;--surface:#0f0f0f;--card:#161616;--border:#222;--accent:#ff5c2b;--text:#f0ede8;--muted:#666;--nav-h:72px}
    body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}
    nav{position:fixed;top:0;left:0;right:0;z-index:100;height:var(--nav-h);display:flex;align-items:center;justify-content:space-between;padding:0 40px;background:rgba(8,8,8,.92);backdrop-filter:blur(20px);border-bottom:1px solid rgba(255,255,255,.05)}
    .logo{font-family:'Syne',sans-serif;font-weight:800;font-size:1.5rem;color:var(--text);text-decoration:none}
    .logo span{color:var(--accent)}
    .nav-r{display:flex;align-items:center;gap:8px}
    .nl{display:flex;align-items:center;gap:5px;padding:7px 16px;border-radius:50px;color:var(--muted);text-decoration:none;font-size:.84rem;font-weight:500;transition:all .2s}
    .nl:hover{background:rgba(255,255,255,.06);color:var(--text)}
    .nl.on{color:var(--accent)}
    .nu{display:flex;align-items:center;gap:8px;background:var(--card);border:1px solid var(--border);border-radius:50px;padding:4px 14px 4px 5px}
    .av{width:30px;height:30px;background:var(--accent);border-radius:50%;display:flex;align-items:center;justify-content:center;font-family:'Syne',sans-serif;font-weight:800;font-size:.72rem;color:#fff}
    .page{max-width:1280px;margin:0 auto;padding:calc(var(--nav-h) + 50px) 40px 80px}
    .ph{margin-bottom:44px}
    .eye{font-size:.71rem;font-weight:600;letter-spacing:2.5px;text-transform:uppercase;color:var(--accent);margin-bottom:10px}
    .ptitle{font-family:'Syne',sans-serif;font-weight:800;font-size:2.6rem;letter-spacing:-1px;margin-bottom:8px}
    .psub{color:var(--muted);font-size:.93rem}
    .fb{display:flex;align-items:center;gap:10px;margin-bottom:44px;flex-wrap:wrap}
    .fbtn{padding:8px 20px;border-radius:50px;border:1px solid var(--border);background:var(--card);color:var(--muted);font-size:.81rem;font-weight:500;cursor:pointer;transition:all .2s;font-family:'DM Sans',sans-serif}
    .fbtn:hover,.fbtn.on{border-color:var(--accent);color:var(--accent);background:rgba(255,92,43,.07)}
    .fbtn.on{font-weight:600}
    .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(308px,1fr));gap:22px}
    .card{background:var(--card);border:1px solid var(--border);border-radius:20px;overflow:hidden;transition:all .3s;animation:fc .5s ease both}
    .card:hover{transform:translateY(-6px);border-color:rgba(255,92,43,.3);box-shadow:0 24px 60px rgba(0,0,0,.5)}
    @keyframes fc{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:translateY(0)}}
    .card:nth-child(1){animation-delay:.03s}.card:nth-child(2){animation-delay:.06s}.card:nth-child(3){animation-delay:.09s}.card:nth-child(4){animation-delay:.12s}.card:nth-child(5){animation-delay:.15s}.card:nth-child(6){animation-delay:.18s}.card:nth-child(7){animation-delay:.21s}.card:nth-child(8){animation-delay:.24s}.card:nth-child(9){animation-delay:.27s}.card:nth-child(10){animation-delay:.30s}.card:nth-child(11){animation-delay:.33s}.card:nth-child(12){animation-delay:.36s}.card:nth-child(13){animation-delay:.39s}.card:nth-child(14){animation-delay:.42s}.card:nth-child(15){animation-delay:.45s}.card:nth-child(16){animation-delay:.48s}.card:nth-child(17){animation-delay:.51s}.card:nth-child(18){animation-delay:.54s}.card:nth-child(19){animation-delay:.57s}.card:nth-child(20){animation-delay:.60s}

    /* IMAGE BANNER */
    .banner{height:175px;overflow:hidden;position:relative}
    .banner img{width:100%;height:100%;object-fit:cover;transition:transform .4s ease;display:block}
    .card:hover .banner img{transform:scale(1.07)}
    .badge{position:absolute;top:11px;left:11px;color:#fff;font-size:.67rem;font-weight:700;padding:4px 10px;border-radius:20px;font-family:'Syne',sans-serif;z-index:1}
    .badge.red{background:var(--accent)}.badge.grn{background:#22c55e}.badge.amb{background:#f59e0b}
    /* dark overlay at bottom of image for readability */
    .banner::after{content:'';position:absolute;bottom:0;left:0;right:0;height:50px;background:linear-gradient(transparent,rgba(22,22,22,.9));pointer-events:none}

    .cb{padding:18px 20px 20px}
    .cr1{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:6px}
    .cn{font-family:'Syne',sans-serif;font-weight:700;font-size:1rem}
    .cc{font-size:.74rem;color:var(--muted);margin-top:2px}
    .rc{display:flex;align-items:center;gap:3px;background:rgba(34,197,94,.1);border:1px solid rgba(34,197,94,.2);padding:3px 9px;border-radius:20px;font-size:.74rem;font-weight:700;color:#4ade80;white-space:nowrap;flex-shrink:0}
    .cd{font-size:.79rem;color:var(--muted);line-height:1.6;margin-bottom:16px}
    .cm{display:flex;align-items:center;justify-content:space-between}
    .mr{display:flex;gap:14px}
    .mi{display:flex;align-items:center;gap:4px;font-size:.76rem;color:var(--muted)}
    .mi strong{color:var(--text);font-weight:500}
    .ot{font-size:.68rem;font-weight:700;color:var(--accent);background:rgba(255,92,43,.1);border:1px solid rgba(255,92,43,.2);padding:3px 9px;border-radius:20px}
    .cf{margin-top:14px;padding-top:14px;border-top:1px solid var(--border);display:flex;align-items:center;justify-content:space-between}
    .cl{font-size:.76rem;color:var(--muted)}
    .mb{background:var(--accent);color:#fff;border:none;padding:8px 17px;border-radius:10px;font-family:'Syne',sans-serif;font-size:.79rem;font-weight:700;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:5px;transition:all .2s}
    .mb:hover{background:#e04d22;transform:scale(1.03)}
    @media(max-width:768px){nav{padding:0 18px}.page{padding:calc(var(--nav-h)+28px) 16px 60px}.ptitle{font-size:1.8rem}.grid{grid-template-columns:1fr}}
  </style>
</head>
<body>
<nav>
  <a class="logo" href="index.jsp">Fork<span>Dash</span></a>
  <div class="nav-r">
    <a href="index.jsp" class="nl">Home</a>
    <a href="restaurant" class="nl on">Restaurants</a>
    <% if ("restaurant_admin".equals(role)) { %><a href="addRestaurant.html" class="nl">+ Add</a><% } %>
    <div class="nu">
      <div class="av"><%= userName.substring(0, Math.min(2, userName.length())).toUpperCase() %></div>
      <span style="font-size:.83rem;font-weight:500"><%= userName %></span>
    </div>
    <a href="logout" class="nl" style="color:#ff5555">Logout</a>
  </div>
</nav>

<div class="page">
  <div class="ph">
    <div class="eye">Explore · Discover · Order</div>
    <h1 class="ptitle">All Restaurants</h1>
    <p class="psub">20 of Bangalore's finest, ready to deliver to your door</p>
  </div>

  <div class="fb">
    <button class="fbtn on" onclick="filter('all',this)">All (20)</button>
    <button class="fbtn" onclick="filter('Italian',this)">🍕 Italian</button>
    <button class="fbtn" onclick="filter('Indian',this)">🍛 Indian</button>
    <button class="fbtn" onclick="filter('American',this)">🍔 American</button>
    <button class="fbtn" onclick="filter('Japanese',this)">🍣 Japanese</button>
    <button class="fbtn" onclick="filter('Mexican',this)">🌮 Mexican</button>
    <button class="fbtn" onclick="filter('Asian',this)">🍜 Asian</button>
    <button class="fbtn" onclick="filter('Healthy',this)">🥗 Healthy</button>
  </div>

  <div class="grid" id="g">

    <!-- 1 Pizza Palace -->
    <div class="card" data-c="Italian">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=200&fit=crop" alt="Pizza Palace"/>
        <div class="badge red">HOT</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Pizza Palace</div><div class="cc">Italian · Wood-fired Pizza</div></div><div class="rc">★ 4.7</div></div><p class="cd">Authentic Neapolitan pizzas baked in a 900°F wood-fired oven with imported Italian flour.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>25–30 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">20% OFF</span></div><div class="cf"><span class="cl">📍 Koramangala</span><a href="menu?restaurant=Pizza Palace" class="mb">Menu →</a></div></div>
    </div>

    <!-- 2 Spice Garden -->
    <div class="card" data-c="Indian">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1596797038530-2c107229654b?w=400&h=200&fit=crop" alt="Spice Garden"/>
        <div class="badge grn">POPULAR</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Spice Garden</div><div class="cc">Indian · Biryani & Curries</div></div><div class="rc">★ 4.5</div></div><p class="cd">Aromatic biryanis slow-cooked with whole spices and aged basmati. Every bite tells a story.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>30–40 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">Free Delivery</span></div><div class="cf"><span class="cl">📍 Indiranagar</span><a href="menu?restaurant=Spice Garden" class="mb">Menu →</a></div></div>
    </div>

    <!-- 3 Burger Barn -->
    <div class="card" data-c="American">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=200&fit=crop" alt="Burger Barn"/>
        <div class="badge amb">NEW</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Burger Barn</div><div class="cc">American · Smash Burgers</div></div><div class="rc">★ 4.3</div></div><p class="cd">Juicy double smash patties on brioche buns with secret sauce and hand-cut fries.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>20–25 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">15% OFF</span></div><div class="cf"><span class="cl">📍 HSR Layout</span><a href="menu?restaurant=Burger Barn" class="mb">Menu →</a></div></div>
    </div>

    <!-- 4 Sushi Zen -->
    <div class="card" data-c="Japanese">
      <div class="banner">
        <img src=data:image/webp;base64,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"Sushi Zen"/>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Sushi Zen</div><div class="cc">Japanese · Premium Sushi</div></div><div class="rc">★ 4.8</div></div><p class="cd">Fresh premium sushi crafted daily by our expert itamae. Flown-in fish twice a week.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>35–45 min</strong></div><div class="mi">🛵 <strong>₹50</strong></div></div><span class="ot">Buy 2 Get 1</span></div><div class="cf"><span class="cl">📍 Whitefield</span><a href="menu?restaurant=Sushi Zen" class="mb">Menu →</a></div></div>
    </div>

    <!-- 5 Taco Fiesta -->
    <div class="card" data-c="Mexican">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=200&fit=crop" alt="Taco Fiesta"/>
        <div class="badge red">HOT</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Taco Fiesta</div><div class="cc">Mexican · Street Tacos</div></div><div class="rc">★ 4.2</div></div><p class="cd">Authentic street-style tacos loaded with carne asada, fresh salsa, and house-made guac.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>20–30 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">Happy Hours</span></div><div class="cf"><span class="cl">📍 Marathahalli</span><a href="menu?restaurant=Taco Fiesta" class="mb">Menu →</a></div></div>
    </div>

    <!-- 6 Tandoor Tales -->
    <div class="card" data-c="Indian">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400&h=200&fit=crop" alt="Tandoor Tales"/>
        <div class="badge grn">TOP RATED</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Tandoor Tales</div><div class="cc">Indian · North Indian</div></div><div class="rc">★ 4.6</div></div><p class="cd">Tender kebabs, creamy gravies, and buttery naans from a traditional clay tandoor oven.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>35–45 min</strong></div><div class="mi">🛵 <strong>₹25</strong></div></div><span class="ot">25% OFF</span></div><div class="cf"><span class="cl">📍 JP Nagar</span><a href="menu?restaurant=Tandoor Tales" class="mb">Menu →</a></div></div>
    </div>

    <!-- 7 Ramen Republic -->
    <div class="card" data-c="Asian">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=200&fit=crop" alt="Ramen Republic"/>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Ramen Republic</div><div class="cc">Asian · Japanese Ramen</div></div><div class="rc">★ 4.5</div></div><p class="cd">Rich tonkotsu broth simmered 18 hours. Hand-pulled noodles. Melt-in-mouth chashu pork.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>30–35 min</strong></div><div class="mi">🛵 <strong>₹40</strong></div></div><span class="ot">Free Gyoza</span></div><div class="cf"><span class="cl">📍 Bellandur</span><a href="menu?restaurant=Ramen Republic" class="mb">Menu →</a></div></div>
    </div>

    <!-- 8 Pasta Pronto -->
    <div class="card" data-c="Italian">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=200&fit=crop" alt="Pasta Pronto"/>
        <div class="badge amb">TRENDING</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Pasta Pronto</div><div class="cc">Italian · Fresh Pasta</div></div><div class="rc">★ 4.4</div></div><p class="cd">Hand-rolled pasta, house-made sauces, and imported Parmigiano. Nonna-approved recipes.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>25–35 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">10% OFF</span></div><div class="cf"><span class="cl">📍 Richmond Town</span><a href="menu?restaurant=Pasta Pronto" class="mb">Menu →</a></div></div>
    </div>

    <!-- 9 Green Bowl -->
    <div class="card" data-c="Healthy">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=200&fit=crop" alt="Green Bowl"/>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Green Bowl</div><div class="cc">Healthy · Salads & Bowls</div></div><div class="rc">★ 4.4</div></div><p class="cd">Power bowls, rainbow salads, and cold-pressed juices. Fuel your day the right way.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>20–28 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">Calorie info</span></div><div class="cf"><span class="cl">📍 Sarjapur Road</span><a href="menu?restaurant=Green Bowl" class="mb">Menu →</a></div></div>
    </div>

    <!-- 10 Crispy Coop -->
    <div class="card" data-c="American">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=400&h=200&fit=crop" alt="Crispy Coop"/>
        <div class="badge grn">POPULAR</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Crispy Coop</div><div class="cc">American · Fried Chicken</div></div><div class="rc">★ 4.6</div></div><p class="cd">Nashville hot chicken with 6 heat levels. Crispy outside, juicy inside — dangerously good.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>22–30 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">Free Fries</span></div><div class="cf"><span class="cl">📍 Yelahanka</span><a href="menu?restaurant=Crispy Coop" class="mb">Menu →</a></div></div>
    </div>

    <!-- 11 Kerala Kitchen -->
    <div class="card" data-c="Indian">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1567337710282-00832b415979?w=400&h=200&fit=crop" alt="Kerala Kitchen"/>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Kerala Kitchen</div><div class="cc">Indian · South Indian Seafood</div></div><div class="rc">★ 4.7</div></div><p class="cd">Coastal Kerala flavors — fish curry, prawn moilee, and crispy karimeen straight from the backwaters.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>35–45 min</strong></div><div class="mi">🛵 <strong>₹35</strong></div></div><span class="ot">20% OFF</span></div><div class="cf"><span class="cl">📍 Jayanagar</span><a href="menu?restaurant=Kerala Kitchen" class="mb">Menu →</a></div></div>
    </div>

    <!-- 12 Dim Sum Delight -->
    <div class="card" data-c="Asian">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400&h=200&fit=crop" alt="Dim Sum Delight"/>
        <div class="badge red">HOT</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Dim Sum Delight</div><div class="cc">Asian · Chinese Dim Sum</div></div><div class="rc">★ 4.5</div></div><p class="cd">Handcrafted dim sum baskets — har gow, char siu bao, and soup dumplings made to order.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>30–40 min</strong></div><div class="mi">🛵 <strong>₹30</strong></div></div><span class="ot">Family Pack</span></div><div class="cf"><span class="cl">📍 Brigade Road</span><a href="menu?restaurant=Dim Sum Delight" class="mb">Menu →</a></div></div>
    </div>

    <!-- 13 Burrito Bros -->
    <div class="card" data-c="Mexican">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=400&h=200&fit=crop" alt="Burrito Bros"/>
        <div class="badge amb">NEW</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Burrito Bros</div><div class="cc">Mexican · Burritos & Bowls</div></div><div class="rc">★ 4.2</div></div><p class="cd">Build-your-own burritos the size of your forearm. Choose your protein, salsa, and toppings.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>18–25 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">₹99 Bowl</span></div><div class="cf"><span class="cl">📍 Electronic City</span><a href="menu?restaurant=Burrito Bros" class="mb">Menu →</a></div></div>
    </div>

    <!-- 14 Gelato Garage -->
    <div class="card" data-c="Italian">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400&h=200&fit=crop" alt="Gelato Garage"/>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Gelato Garage</div><div class="cc">Italian · Artisan Gelato</div></div><div class="rc">★ 4.9</div></div><p class="cd">Creamy Italian gelato in 30+ rotating flavors. No artificial colors or preservatives. Pure joy.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>15–20 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">Buy 3 Get 1</span></div><div class="cf"><span class="cl">📍 MG Road</span><a href="menu?restaurant=Gelato Garage" class="mb">Menu →</a></div></div>
    </div>

    <!-- 15 Chaat House -->
    <div class="card" data-c="Indian">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=400&h=200&fit=crop" alt="Chaat House"/>
        <div class="badge grn">TOP RATED</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Chaat House</div><div class="cc">Indian · Street Food</div></div><div class="rc">★ 4.6</div></div><p class="cd">Mumbai-style pani puri, bhel, and sev puri. Nostalgia on a plate, delivered blazing fast.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>20–28 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">Combo Deals</span></div><div class="cf"><span class="cl">📍 Malleshwaram</span><a href="menu?restaurant=Chaat House" class="mb">Menu →</a></div></div>
    </div>

    <!-- 16 Smoothie Studio -->
    <div class="card" data-c="Healthy">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1502741224143-90386d7f8c82?w=400&h=200&fit=crop" alt="Smoothie Studio"/>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Smoothie Studio</div><div class="cc">Healthy · Smoothies & Acai</div></div><div class="rc">★ 4.3</div></div><p class="cd">Cold-pressed juices, acai bowls, and protein-packed smoothies. Your post-workout best friend.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>15–22 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">No sugar opt</span></div><div class="cf"><span class="cl">📍 Koramangala</span><a href="menu?restaurant=Smoothie Studio" class="mb">Menu →</a></div></div>
    </div>

    <!-- 17 Thai Orchid -->
    <div class="card" data-c="Asian">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1559314809-0d155014e29e?w=400&h=200&fit=crop" alt="Thai Orchid"/>
        <div class="badge red">HOT</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Thai Orchid</div><div class="cc">Asian · Thai Cuisine</div></div><div class="rc">★ 4.7</div></div><p class="cd">Authentic pad thai, green curry, and tom yum soup. Thai spices imported fresh every fortnight.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>30–40 min</strong></div><div class="mi">🛵 <strong>₹40</strong></div></div><span class="ot">15% OFF</span></div><div class="cf"><span class="cl">📍 Banaswadi</span><a href="menu?restaurant=Thai Orchid" class="mb">Menu →</a></div></div>
    </div>

    <!-- 18 Donut District -->
    <div class="card" data-c="American">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1551024601-bec78aea704b?w=400&h=200&fit=crop" alt="Donut District"/>
        <div class="badge amb">TRENDING</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Donut District</div><div class="cc">American · Artisan Donuts</div></div><div class="rc">★ 4.5</div></div><p class="cd">Brioche donuts with outrageous toppings — Oreo crumble, matcha glaze, and daily specials.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>18–25 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">Half dozen deal</span></div><div class="cf"><span class="cl">📍 Bannerghatta Rd</span><a href="menu?restaurant=Donut District" class="mb">Menu →</a></div></div>
    </div>

    <!-- 19 Chettinad Corner -->
    <div class="card" data-c="Indian">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1574653853027-5382a3d23a15?w=400&h=200&fit=crop" alt="Chettinad Corner"/>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Chettinad Corner</div><div class="cc">Indian · Chettinad</div></div><div class="rc">★ 4.8</div></div><p class="cd">Bold Chettinad spices in slow-cooked chicken, mutton, and crab. An explosion of flavor.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>40–50 min</strong></div><div class="mi">🛵 <strong>₹30</strong></div></div><span class="ot">Chef Special</span></div><div class="cf"><span class="cl">📍 Basavanagudi</span><a href="menu?restaurant=Chettinad Corner" class="mb">Menu →</a></div></div>
    </div>

    <!-- 20 Plant & Plate -->
    <div class="card" data-c="Healthy">
      <div class="banner">
        <img src="https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=200&fit=crop" alt="Plant and Plate"/>
        <div class="badge grn">VEGAN</div>
      </div>
      <div class="cb"><div class="cr1"><div><div class="cn">Plant &amp; Plate</div><div class="cc">Healthy · Vegan &amp; Veg</div></div><div class="rc">★ 4.4</div></div><p class="cd">100% plant-based that actually tastes incredible. Wraps, burgers, and hearty grain bowls.</p><div class="cm"><div class="mr"><div class="mi">🕐 <strong>22–30 min</strong></div><div class="mi">🛵 <strong>Free</strong></div></div><span class="ot">Zero guilt</span></div><div class="cf"><span class="cl">📍 Sadashivanagar</span><a href="menu?restaurant=Plant+%26+Plate" class="mb">Menu →</a></div></div>
    </div>

  </div>
</div>

<script>
function filter(c,btn){
  document.querySelectorAll('.fbtn').forEach(b=>b.classList.remove('on'));
  btn.classList.add('on');
  document.querySelectorAll('.card').forEach(card=>{
    card.style.display=(c==='all'||card.dataset.c===c)?'':'none';
  });
}
</script>
</body>
</html>
