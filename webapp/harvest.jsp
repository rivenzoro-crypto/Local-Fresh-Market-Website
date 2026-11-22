<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Harvest | Fresh Market</title>
<link href="${pageContext.request.contextPath}/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
:root {
	--green: #2C4A3E;
	--gold: #C5A059;
	--cream: #FAF9F5;
	--muted: #6B7C76
}

body {
	background: var(--cream);
	color: #1C2826
}

.harvest-hero {
	background: linear-gradient(135deg, #234438, #406b54);
	color: #fff;
	border-radius: 28px;
	overflow: hidden
}

.eyebrow {
	color: #e5c98b;
	letter-spacing: 2px;
	font-size: .75rem;
	font-weight: 700;
	text-transform: uppercase
}

.process-card, .category-card, .product-card {
	background: #fff;
	border: 1px solid rgba(44, 74, 62, .09);
	border-radius: 20px;
	box-shadow: 0 8px 25px rgba(28, 40, 38, .04)
}

.process-icon {
	width: 58px;
	height: 58px;
	border-radius: 50%;
	display: grid;
	place-items: center;
	background: #edf3ef;
	color: var(--green);
	font-size: 1.5rem
}

.category-card {
	transition: .25s
}

.category-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 15px 30px rgba(28, 40, 38, .08)
}

.product-image {
	width: 100%;
	aspect-ratio: 1;
	object-fit: cover;
	background: #eef1ee
}

.fallback {
	display: grid;
	place-items: center;
	background: #eef1ee;
	color: var(--green);
	font-size: 3rem
}

.btn-fresh {
	background: var(--green);
	border: none;
	color: #fff;
	border-radius: 50rem;
	padding: .7rem 1.3rem;
	font-weight: 600
}

.btn-fresh:hover {
	background: #1c3228;
	color: #fff
}

.season-pill {
	display: inline-block;
	background: #f3ead7;
	color: #7c6027;
	border-radius: 50rem;
	padding: .35rem .8rem;
	font-size: .78rem;
	font-weight: 700
}
</style>
</head>
<body>
	<jsp:include page="components/menuBar.jsp" />
	<main class="container py-4 py-md-5">
		<section class="harvest-hero p-4 p-md-5 mb-5">
			<div class="row align-items-center g-4">
				<div class="col-lg-7">
					<div class="eyebrow mb-3" data-en="Freshness in every season" data-mm="လတ်ဆတ်သောရိတ်သိမ်းမှု">Freshness in every season</div>
					<h1 class="display-5 fw-bold" data-en="From farm to your table" data-mm="ခြံမှ သင့်စားပွဲဆီသို့">From farm to your table.</h1>
					<p class="lead opacity-75 mb-4" data-en="Discover fresh products,
						explore our seasonal categories, and shop ingredients selected for
						everyday meals" data-mm="လတ်ဆတ်သော ကုန်ပစ္စည်းများကို ရှာဖွေလိုက်ပါ။ ရာသီအလိုက် အမျိုးအစားများကို လေ့လာကြည့်ရှုပြီး နေ့စဉ် အစားအစာများအတွက် ရွေးချယ်ထားသော ပါဝင်ပစ္စည်းများကို ဝယ်ယူလိုက်ပါ။">Discover fresh products,
						explore our seasonal categories, and shop ingredients selected for
						everyday meals.</p>
					<a class="btn btn-light rounded-pill px-4 fw-semibold" data-en="Explore today’s harvest" data-mm="ယနေ့ ရိတ်သိမ်းရရှိထားသည်များကို လေ့လာကြည့်ရှုလိုက်ပါ"
						href="#featured">Explore today’s harvest <i
						class="bi bi-arrow-down ms-1"></i></a>
				</div>
				<div class="col-lg-5">
					<div class="p-4 rounded-4"
						style="background: rgba(255, 255, 255, .10)">
						<div class="display-1">🌱</div>
						<h2 class="h4 mt-3" data-en="Fresh. Simple. Local-minded." data-mm="လတ်ဆတ်သည်။ ရိုးရှင်းသည်။ ဒေသအပေါ် အလေးထားသည်။">Fresh. Simple. Local-minded.</h2>
						<p class="mb-0 opacity-75" data-en="Good food starts with ingredients
							you can feel good about" data-mm="ကောင်းမွန်တဲ့ အစားအစာဟာ ပါဝင်ပစ္စည်းတွေနဲ့ စတင်ပါတယ်။ သင်ကောင်းကောင်းခံစားရနိုင်ပါတယ်။">Good food starts with ingredients
							you can feel good about.</p>
					</div>
				</div>
			</div>
		</section>
		<section class="mb-5">
			<div class="text-center mb-4">
				<span class="season-pill" data-en="SHOP BY CATEGORY"data-mm="အမျိုးအစားအလိုက် ရှာဖွေဝယ်ယူပါ">SHOP BY CATEGORY</span>
				<h2 class="mt-3 fw-bold" data-en="What are you harvesting today?" data-mm="ဒီနေ့ ဘာတွေ ရိတ်သိမ်းနေတာလဲ။">What are you harvesting today?</h2>
				<p class="text-secondary" data-en="Choose a category and browse the
					products currently available." data-mm="အမျိုးအစားတစ်ခုကို ရွေးချယ်ပြီး လက်ရှိရရှိနိုင်သော
ထုတ်ကုန်များကို ကြည့်ရှုပါ။">Choose a category and browse the
					products currently available.</p>
			</div>
			<div class="row g-3">
				<c:forEach var="category" items="${categories}">
					<div class="col-6 col-md-4 col-lg-3">
						<a
							class="category-card d-block h-100 p-4 text-decoration-none text-dark"
							href="${pageContext.request.contextPath}/home?category=${category.slug}"><i
							class="bi bi-basket2-fill fs-3 text-success"></i>
						<h3 class="h6 fw-bold mt-3 mb-1">
								<c:out value="${category.name}" />
							</h3>
							<span class="small text-secondary" data-en="Browse fresh products" data-mm="လတ်ဆတ်သော ထုတ်ကုန်များကို ကြည့်ရှုပါ">Browse fresh products <i
								class="bi bi-arrow-right"></i></span></a>
					</div>
				</c:forEach>
			</div>
		</section>
		<section class="mb-5">
			<div class="text-center mb-4">
				<span class="season-pill" data-en="OUR PROCESS" data-mm="ကျွန်ုပ်တို့၏ လုပ်ငန်းစဉ်"> OUR PROCESS</span>
				<h2 class="mt-3 fw-bold" data-en="How freshness get to you" data-mm="လတ်ဆတ်မှု သင့်ထံသို့ ရောက်ရှိလာပုံ">How freshness gets to you</h2>
			</div>
			<div class="row g-3">
				<div class="col-md-3">
					<div class="process-card p-4 h-100">
						<div class="process-icon">
							<i class="bi bi-tree"></i>
						</div>
						<h3 class="h5 mt-3" data-en="1.Grown with care" data-mm="(၁) ဂရုတစိုက် စိုက်ပျိုးထားသည်">1. Grown with care</h3>
						<p class="text-secondary mb-0" data-en="We focus on products chosen for
							quality and everyday freshness" data-mm="ကျွန်ုပ်တို့သည် အရည်အသွေးနှင့် နေ့စဉ်လတ်ဆတ်မှုတို့အတွက် ရွေးချယ်ထားသော ထုတ်ကုန်များကို အလေးထားပါသည်။">We focus on products chosen for
							quality and everyday freshness.</p>
					</div>
				</div>
				<div class="col-md-3">
					<div class="process-card p-4 h-100">
						<div class="process-icon">
							<i class="bi bi-flower1"></i>
						</div>
						<h3 class="h5 mt-3" data-en="2. Carefully harvested" data-mm="(၂) ဂရုတစိုက် ရိတ်သိမ်းထားသည်">2. Carefully harvested</h3>
						<p class="text-secondary mb-0" data-en="Seasonal ingredients are
							selected at the right time" data-mm="ရာသီအလိုက် ပါဝင်ပစ္စည်းများကို
သင့်လျော်သော အချိန်တွင် ရွေးချယ်ထားပါသည်">Seasonal ingredients are
							selected at the right time.</p>
					</div>
				</div>
				<div class="col-md-3">
					<div class="process-card p-4 h-100">
						<div class="process-icon">
							<i class="bi bi-clipboard2-check"></i>
						</div>
						<h3 class="h5 mt-3" data-en="3. Quality checked" data-mm="(၃) အရည်အသွေး စစ်ဆေးပြီး">3. Quality checked</h3>
						<p class="text-secondary mb-0" data-en="Products are reviewed before
							becoming part of our catalog." data-mm="ထုတ်ကုန်များကို ကျွန်ုပ်တို့၏ ကုန်ပစ္စည်းစာရင်းတွင် မထည့်သွင်းမီ စိစစ်သုံးသပ်မှု ပြုလုပ်ပါသည်။">Products are reviewed before
							becoming part of our catalog.</p>
					</div>
				</div>
				<div class="col-md-3">
					<div class="process-card p-4 h-100">
						<div class="process-icon">
							<i class="bi bi-bag-check"></i>
						</div>
						<h3 class="h5 mt-3" data-en="4. Ready to shop" data-mm="(၄) ဈေးဝယ်ရန် အဆင်သင့်ဖြစ်ပါပြီ">4. Ready to shop</h3>
						<p class="text-secondary mb-0" data-en="Browse online and add your
							favorites to your cart." data-mm="အွန်လိုင်းတွင် ကြည့်ရှုပြီး သင်နှစ်သက်ရာများကို ဈေးခြင်းတောင်းထဲသို့ ထည့်ပါ။">Browse online and add your
							favorites to your cart.</p>
					</div>
				</div>
			</div>
		</section>
		
		<section class="text-center p-4 p-md-5 rounded-4"
			style="background: #edf3ef">
			<h2 class="fw-bold" data-en="Ready for something fresh?" data-mm="အသစ်အဆန်းတစ်ခုခုအတွက် အဆင်သင့်ဖြစ်ပြီလား။">Ready for something fresh?</h2>
			<p class="text-secondary" data-en="Browse the full Fresh Market
				collection" data-mm="Fresh Market စုစည်းမှုအပြည့်အစုံကို ကြည့်ရှုပါ">Browse the full Fresh Market
				collection.</p>
			<a href="${pageContext.request.contextPath}/home"
				class="btn btn-fresh" data-en="Shop Fresh Products" data-mm="လတ်ဆတ်သော ကုန်ပစ္စည်းများကို ဝယ်ယူပါ">Shop Fresh Products <i
				class="bi bi-arrow-right ms-1"></i></a>
		</section>
	</main>
	<script
		src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
