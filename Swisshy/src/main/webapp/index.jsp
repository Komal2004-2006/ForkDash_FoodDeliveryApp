<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
HttpSession s = request.getSession(false);
String userName = null;
String role = null;
if (s != null && s.getAttribute("loggedUser") != null) {
	userName = (String) s.getAttribute("userName");
	role = (String) s.getAttribute("role");
}
boolean loggedIn = (userName != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>ForkDash — Food. Fast. Fabulous.</title>
<link
	href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&display=swap"
	rel="stylesheet" />
<style>
*, *::before, *::after {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

:root {
	--bg: #080808;
	--surface: #0f0f0f;
	--card: #181818;
	--border: #222;
	--accent: #ff5c2b;
	--accent2: #ffb347;
	--text: #f0ede8;
	--muted: #666;
	--nav-h: 72px;
}

html {
	scroll-behavior: smooth;
}

body {
	font-family: 'DM Sans', sans-serif;
	background: var(--bg);
	color: var(--text);
	min-height: 100vh;
	overflow-x: hidden;
}

nav {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	z-index: 200;
	height: var(--nav-h);
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 0 48px;
	background: rgba(8, 8, 8, 0.88);
	backdrop-filter: blur(22px);
	border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.nav-logo {
	font-family: 'Syne', sans-serif;
	font-weight: 800;
	font-size: 1.6rem;
	color: var(--text);
	text-decoration: none;
	letter-spacing: -0.5px;
}

.nav-logo span {
	color: var(--accent);
}

.nav-right {
	display: flex;
	align-items: center;
	gap: 8px;
}

.nav-link {
	display: flex;
	align-items: center;
	gap: 6px;
	padding: 8px 18px;
	border-radius: 50px;
	color: var(--muted);
	text-decoration: none;
	font-size: 0.88rem;
	font-weight: 500;
	transition: all 0.2s;
}

.nav-link:hover {
	background: rgba(255, 255, 255, 0.06);
	color: var(--text);
}

.nav-btn {
	background: var(--accent);
	color: #fff;
	border: none;
	padding: 9px 22px;
	border-radius: 50px;
	font-family: 'Syne', sans-serif;
	font-weight: 700;
	font-size: 0.88rem;
	cursor: pointer;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 6px;
	transition: background 0.2s;
}

.nav-btn:hover {
	background: #e04d22;
}

.nav-user {
	display: flex;
	align-items: center;
	gap: 10px;
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: 50px;
	padding: 5px 16px 5px 6px;
}

.nav-avatar {
	width: 32px;
	height: 32px;
	background: var(--accent);
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-family: 'Syne', sans-serif;
	font-weight: 800;
	font-size: 0.75rem;
	color: #fff;
}

.nav-username {
	font-size: 0.85rem;
	font-weight: 500;
}

/* HERO */
.hero {
	min-height: 100vh;
	padding-top: var(--nav-h);
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	text-align: center;
	position: relative;
	overflow: hidden;
	padding: calc(var(--nav-h)+ 40px) 24px 80px;
}

.hero-glow {
	position: absolute;
	inset: 0;
	pointer-events: none;
	background: radial-gradient(ellipse 80% 60% at 50% 20%, rgba(255, 92, 43, 0.13)
		0%, transparent 65%),
		radial-gradient(ellipse 50% 40% at 85% 90%, rgba(255, 179, 71, 0.07)
		0%, transparent 60%);
}

.hero-dots {
	position: absolute;
	inset: 0;
	pointer-events: none;
	opacity: 0.025;
	background-image: radial-gradient(rgba(255, 255, 255, 0.8) 1px,
		transparent 1px);
	background-size: 32px 32px;
}

.float-emoji {
	position: absolute;
	font-size: 1.8rem;
	opacity: 0.06;
	pointer-events: none;
	animation: floatDrift linear infinite;
}

@
keyframes floatDrift { 0% {
	transform: translateY(100vh) rotate(0deg);
	opacity: 0;
}

8


%
{
opacity


:


0
.06
;


}
92


%
{
opacity


:


0
.06
;


}
100


%
{
transform


:


translateY
(


-20vh


)


rotate
(


540deg


)
;


opacity


:


0
;


}
}
.hero-pill {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	background: rgba(255, 92, 43, 0.08);
	border: 1px solid rgba(255, 92, 43, 0.2);
	color: var(--accent);
	padding: 7px 18px;
	border-radius: 50px;
	font-size: 0.77rem;
	font-weight: 600;
	letter-spacing: 1.8px;
	text-transform: uppercase;
	margin-bottom: 36px;
	animation: slideDown 0.7s ease both;
}

.pulse-dot {
	width: 6px;
	height: 6px;
	background: var(--accent);
	border-radius: 50%;
	animation: pulse 1.8s infinite;
}

@
keyframes pulse { 0%,100%{
	opacity: 1;
	transform: scale(1)
}

50


%
{
opacity


:


0
.3
;


transform


:


scale
(


0
.6


)


}
}
@
keyframes slideDown {
	from {opacity: 0;
	transform: translateY(-20px)
}

to {
	opacity: 1;
	transform: translateY(0)
}

}
@
keyframes slideUp {
	from {opacity: 0;
	transform: translateY(30px)
}

to {
	opacity: 1;
	transform: translateY(0)
}

}
.hero-h1 {
	font-family: 'Syne', sans-serif;
	font-weight: 800;
	font-size: clamp(3.5rem, 9vw, 7.5rem);
	line-height: 0.9;
	letter-spacing: -3px;
	margin-bottom: 30px;
	animation: slideUp 0.8s 0.1s ease both;
}

.hero-h1 .line-accent {
	color: var(--accent);
}

.hero-h1 .line-dim {
	color: rgba(240, 237, 232, 0.3);
}

.hero-sub {
	font-size: clamp(1rem, 2.2vw, 1.2rem);
	color: var(--muted);
	line-height: 1.75;
	max-width: 500px;
	margin-bottom: 52px;
	animation: slideUp 0.8s 0.2s ease both;
}

.hero-actions {
	display: flex;
	align-items: center;
	gap: 14px;
	flex-wrap: wrap;
	justify-content: center;
	animation: slideUp 0.8s 0.3s ease both;
}

.btn-primary {
	background: var(--accent);
	color: #fff;
	text-decoration: none;
	padding: 16px 38px;
	border-radius: 60px;
	font-family: 'Syne', sans-serif;
	font-size: 1rem;
	font-weight: 700;
	display: inline-flex;
	align-items: center;
	gap: 10px;
	box-shadow: 0 8px 30px rgba(255, 92, 43, 0.35);
	transition: all 0.2s;
}

.btn-primary:hover {
	background: #e04d22;
	transform: translateY(-2px);
	box-shadow: 0 16px 40px rgba(255, 92, 43, 0.45);
}

.btn-ghost {
	background: transparent;
	border: 1px solid var(--border);
	color: var(--muted);
	text-decoration: none;
	padding: 16px 32px;
	border-radius: 60px;
	font-size: 0.95rem;
	font-weight: 500;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	transition: all 0.2s;
}

.btn-ghost:hover {
	border-color: rgba(255, 255, 255, 0.3);
	color: var(--text);
	background: rgba(255, 255, 255, 0.04);
}

/* STATS */
.stats {
	background: var(--surface);
	border-top: 1px solid var(--border);
	border-bottom: 1px solid var(--border);
}

.stats-inner {
	max-width: 900px;
	margin: 0 auto;
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	padding: 0 48px;
}

.stat {
	padding: 32px 20px;
	text-align: center;
	border-right: 1px solid var(--border);
}

.stat:last-child {
	border-right: none;
}

.stat-n {
	font-family: 'Syne', sans-serif;
	font-weight: 800;
	font-size: 2.2rem;
	color: var(--accent);
}

.stat-l {
	font-size: 0.75rem;
	color: var(--muted);
	letter-spacing: 1.2px;
	text-transform: uppercase;
	margin-top: 4px;
}

/* HOW IT WORKS */
.sec {
	max-width: 1200px;
	margin: 0 auto;
	padding: 100px 48px;
}

.eyebrow {
	font-size: 0.73rem;
	font-weight: 600;
	letter-spacing: 3px;
	color: var(--accent);
	text-transform: uppercase;
	margin-bottom: 14px;
}

.sec-title {
	font-family: 'Syne', sans-serif;
	font-weight: 800;
	font-size: clamp(2rem, 4vw, 3rem);
	line-height: 1.05;
	margin-bottom: 16px;
}

.sec-sub {
	color: var(--muted);
	font-size: 0.97rem;
	max-width: 460px;
	line-height: 1.75;
	margin-bottom: 60px;
}

.steps {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 20px;
}

.step {
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: 20px;
	padding: 36px 28px;
	position: relative;
	overflow: hidden;
	transition: all 0.3s;
}

.step:hover {
	border-color: rgba(255, 92, 43, 0.3);
	transform: translateY(-5px);
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
}

.step-bg-num {
	font-family: 'Syne', sans-serif;
	font-weight: 800;
	font-size: 5rem;
	color: rgba(255, 92, 43, 0.05);
	position: absolute;
	bottom: -8px;
	right: 16px;
}

.step-ico {
	font-size: 2.4rem;
	margin-bottom: 22px;
}

.step-t {
	font-family: 'Syne', sans-serif;
	font-weight: 700;
	font-size: 1.05rem;
	margin-bottom: 10px;
}

.step-d {
	font-size: 0.85rem;
	color: var(--muted);
	line-height: 1.7;
}

/* CUISINE */
.cuisine-bg {
	background: var(--surface);
	padding: 80px 0;
}

.cuisine-inner {
	max-width: 1200px;
	margin: 0 auto;
	padding: 0 48px;
}

.pills {
	display: flex;
	flex-wrap: wrap;
	gap: 12px;
	margin-top: 44px;
}

.pill {
	display: flex;
	align-items: center;
	gap: 10px;
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: 50px;
	padding: 12px 22px;
	font-size: 0.88rem;
	font-weight: 500;
	text-decoration: none;
	color: var(--text);
	transition: all 0.2s;
}

.pill:hover {
	border-color: var(--accent);
	color: var(--accent);
	background: rgba(255, 92, 43, 0.05);
	transform: translateY(-2px);
}

.pill-ico {
	font-size: 1.25rem;
}

/* PERKS */
.perks-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 18px;
}

.perk {
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: 18px;
	padding: 28px 28px;
	display: flex;
	gap: 18px;
	align-items: flex-start;
	transition: all 0.25s;
}

.perk:hover {
	border-color: rgba(255, 92, 43, 0.2);
	transform: translateY(-2px);
}

.perk-ico-box {
	width: 50px;
	height: 50px;
	border-radius: 14px;
	flex-shrink: 0;
	background: rgba(255, 92, 43, 0.1);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.4rem;
}

.perk-t {
	font-family: 'Syne', sans-serif;
	font-weight: 700;
	font-size: 0.97rem;
	margin-bottom: 6px;
}

.perk-d {
	font-size: 0.83rem;
	color: var(--muted);
	line-height: 1.65;
}

/* CTA */
.cta {
	padding: 120px 48px;
	text-align: center;
	position: relative;
	overflow: hidden;
}

.cta::before {
	content: '';
	position: absolute;
	top: -80px;
	left: 50%;
	transform: translateX(-50%);
	width: 700px;
	height: 500px;
	background: radial-gradient(ellipse, rgba(255, 92, 43, 0.1) 0%,
		transparent 70%);
	pointer-events: none;
}

.cta-t {
	font-family: 'Syne', sans-serif;
	font-weight: 800;
	font-size: clamp(2.5rem, 5vw, 4.5rem);
	margin-bottom: 20px;
	line-height: 1.05;
}

.cta-t em {
	color: var(--accent);
	font-style: normal;
}

.cta-s {
	color: var(--muted);
	font-size: 1rem;
	max-width: 420px;
	margin: 0 auto 50px;
	line-height: 1.75;
}

/* FOOTER */
.footer {
	max-width: 1200px;
	margin: 0 auto;
	padding: 36px 48px;
	border-top: 1px solid var(--border);
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.footer-logo {
	font-family: 'Syne', sans-serif;
	font-weight: 800;
	font-size: 1.2rem;
	color: var(--muted);
}

.footer-logo span {
	color: var(--accent);
}

.footer-c {
	font-size: 0.78rem;
	color: var(--muted);
}

@media ( max-width : 768px) {
	nav {
		padding: 0 20px;
	}
	.stats-inner {
		grid-template-columns: repeat(2, 1fr);
		padding: 0 20px;
	}
	.stat {
		border-right: none;
		border-bottom: 1px solid var(--border);
	}
	.stat:nth-child(2) {
		border-right: none;
	}
	.steps {
		grid-template-columns: 1fr;
	}
	.perks-grid {
		grid-template-columns: 1fr;
	}
	.sec {
		padding: 60px 20px;
	}
	.cuisine-inner {
		padding: 0 20px;
	}
	.cta {
		padding: 80px 20px;
	}
	.footer {
		flex-direction: column;
		gap: 12px;
		text-align: center;
		padding: 28px 20px;
	}
}
</style>
</head>
<body>

	<nav>
		<a class="nav-logo" href="index.jsp">Fork<span>Dash</span></a>
		<div class="nav-right">
			<%
			if (loggedIn) {
			%>
			<a href="restaurant" class="nav-link">🍽️ Restaurants</a>
			
			<div class="nav-user">
				<div class="nav-avatar"><%=userName.substring(0, Math.min(2, userName.length())).toUpperCase()%></div>
				<span class="nav-username"><%=userName%></span>
			</div>
			<a href="logout" class="nav-link"
				style="color: #ff5555; font-size: 0.82rem;">Logout</a>
			<%
			} else {
			%>
			<a href="login.html" class="nav-link">Sign In</a> <a
				href="registration.html" class="nav-btn">Get Started →</a>
			<%
			}
			%>
		</div>
	</nav>

	<section class="hero">
		<div class="hero-glow"></div>
		<div class="hero-dots"></div>
		<!-- floating food -->
		<span class="float-emoji"
			style="left: 4%; animation-duration: 20s; animation-delay: 0s;">🍕</span>
		<span class="float-emoji"
			style="left: 14%; animation-duration: 25s; animation-delay: 4s;">🍣</span>
		<span class="float-emoji"
			style="left: 24%; animation-duration: 18s; animation-delay: 8s;">🌮</span>
		<span class="float-emoji"
			style="left: 42%; animation-duration: 22s; animation-delay: 2s;">🍔</span>
		<span class="float-emoji"
			style="left: 57%; animation-duration: 19s; animation-delay: 6s;">🍜</span>
		<span class="float-emoji"
			style="left: 70%; animation-duration: 26s; animation-delay: 3s;">🥗</span>
		<span class="float-emoji"
			style="left: 80%; animation-duration: 21s; animation-delay: 9s;">🍛</span>
		<span class="float-emoji"
			style="left: 91%; animation-duration: 17s; animation-delay: 1s;">🧆</span>

		<div class="hero-pill">
			<div class="pulse-dot"></div>
			Now live in Bangalore
		</div>
		<h1 class="hero-h1">
			<span class="line-accent">Crave it.</span><br /> Order it.<br /> <span
				class="line-dim">Devour it.</span>
		</h1>
		<p class="hero-sub">ForkDash brings the best restaurants in your
			city straight to your door — hot, fresh, and absurdly fast.</p>
		<div class="hero-actions">
			<%
			if (loggedIn) {
			%>
			<a href="restaurant" class="btn-primary">Browse Restaurants <span>→</span></a>
			<%
			if ("restaurant_admin".equals(role)) {
			%>
			<a href="addRestaurant.html" class="btn-ghost">+ Add Restaurant</a>
			<%
			}
			%>
			<%
			} else {
			%>
			<a href="registration.html" class="btn-primary">Start Ordering
				Free →</a> <a href="login.html" class="btn-ghost">I have an account</a>
			<%
			}
			%>
		</div>
	</section>

	<div class="stats">
		<div class="stats-inner">
			<div class="stat">
				<div class="stat-n">200+</div>
				<div class="stat-l">Restaurants</div>
			</div>
			<div class="stat">
				<div class="stat-n">50k+</div>
				<div class="stat-l">Happy Orders</div>
			</div>
			<div class="stat">
				<div class="stat-n">28 min</div>
				<div class="stat-l">Avg Delivery</div>
			</div>
			<div class="stat">
				<div class="stat-n">4.8 ★</div>
				<div class="stat-l">Customer Rating</div>
			</div>
		</div>
	</div>

	<div class="sec">
		<div class="eyebrow">How It Works</div>
		<h2 class="sec-title">
			Three steps to your<br />next favourite meal
		</h2>
		<p class="sec-sub">From craving to doorstep in under 30 minutes.
			It really is that simple.</p>
		<div class="steps">
			<div class="step">
				<div class="step-bg-num">01</div>
				<div class="step-ico">🔍</div>
				<div class="step-t">Browse & Discover</div>
				<div class="step-d">Explore hundreds of restaurants. Filter by
					cuisine, rating, or delivery time.</div>
			</div>
			<div class="step">
				<div class="step-bg-num">02</div>
				<div class="step-ico">🛒</div>
				<div class="step-t">Pick & Customize</div>
				<div class="step-d">Build your perfect order. Add items,
					choose extras, check out in seconds.</div>
			</div>
			<div class="step">
				<div class="step-bg-num">03</div>
				<div class="step-ico">🚀</div>
				<div class="step-t">Fast Delivery</div>
				<div class="step-d">Sit back while our riders bring your food
					hot and fresh to your door.</div>
			</div>
		</div>
	</div>

	<div class="cuisine-bg">
		<div class="cuisine-inner">
			<div class="eyebrow">Explore Cuisines</div>
			<h2 class="sec-title">What are you craving?</h2>
			<div class="pills">
				<a href="restaurant" class="pill"><span class="pill-ico">🍕</span>Italian</a>
				<a href="restaurant" class="pill"><span class="pill-ico">🍔</span>American</a>
				<a href="restaurant" class="pill"><span class="pill-ico">🍛</span>Indian</a>
				<a href="restaurant" class="pill"><span class="pill-ico">🍜</span>Asian</a>
				<a href="restaurant" class="pill"><span class="pill-ico">🌮</span>Mexican</a>
				<a href="restaurant" class="pill"><span class="pill-ico">🍣</span>Japanese</a>
				<a href="restaurant" class="pill"><span class="pill-ico">🥙</span>Mediterranean</a>
				<a href="restaurant" class="pill"><span class="pill-ico">🧆</span>Middle
					Eastern</a> <a href="restaurant" class="pill"><span
					class="pill-ico">🥗</span>Healthy</a> <a href="restaurant" class="pill"><span
					class="pill-ico">🍰</span>Desserts</a> <a href="restaurant"
					class="pill"><span class="pill-ico">🥤</span>Beverages</a> <a
					href="restaurant" class="pill"><span class="pill-ico">🌿</span>Vegan</a>
			</div>
		</div>
	</div>

	<div class="sec">
		<div class="eyebrow">Why ForkDash</div>
		<h2 class="sec-title">
			The perks of<br />ordering smarter
		</h2>
		<p class="sec-sub">We didn't just build another food app — we
			built a better way to eat.</p>
		<div class="perks-grid">
			<div class="perk">
				<div class="perk-ico-box">⚡</div>
				<div>
					<div class="perk-t">Lightning Delivery</div>
					<div class="perk-d">Average delivery in under 30 minutes. Our
						rider network is always nearby.</div>
				</div>
			</div>
			<div class="perk">
				<div class="perk-ico-box">🔒</div>
				<div>
					<div class="perk-t">Secure Payments</div>
					<div class="perk-d">All transactions encrypted. Pay by card,
						UPI, or cash on delivery.</div>
				</div>
			</div>
			<div class="perk">
				<div class="perk-ico-box">🎁</div>
				<div>
					<div class="perk-t">Daily Exclusive Deals</div>
					<div class="perk-d">Members get access to daily offers, combo
						discounts, and surprise freebies.</div>
				</div>
			</div>
			<div class="perk">
				<div class="perk-ico-box">⭐</div>
				<div>
					<div class="perk-t">Quality Verified</div>
					<div class="perk-d">Every restaurant is rated by real
						customers. Only the best make it here.</div>
				</div>
			</div>
		</div>
	</div>

	<div class="cta">
		<h2 class="cta-t">
			Ready to eat<br /> <em>something amazing?</em>
		</h2>
		<p class="cta-s">Join thousands of food lovers across Bangalore
			who order with ForkDash every day.</p>
		<div class="hero-actions">
			<%
			if (loggedIn) {
			%>
			<a href="restaurant" class="btn-primary">Browse Restaurants →</a>
			<%
			} else {
			%>
			<a href="registration.html" class="btn-primary">Create Free
				Account →</a> <a href="login.html" class="btn-ghost">Already a
				member?</a>
			<%
			}
			%>
		</div>
	</div>

	<div style="border-top: 1px solid var(--border);">
		<div class="footer">
			<div class="footer-logo">
				Fork<span>Dash</span>
			</div>
			<div class="footer-c">© 2025 ForkDash · Made with ❤️ for food
				lovers in Bangalore</div>
		</div>
	</div>

</body>
</html>
