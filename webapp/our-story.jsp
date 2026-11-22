<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Our Story | Fresh Market</title>
<link href="${pageContext.request.contextPath}/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
:root {
	--green: #2C4A3E;
	--gold: #C5A059;
	--cream: #FAF9F5
}

body {
	background: var(--cream);
	color: #1C2826
}

.story-hero {
	background: linear-gradient(135deg, #f2ead9, #fff);
	border: 1px solid rgba(44, 74, 62, .1);
	border-radius: 28px
}

.eyebrow {
	color: #8c6d2d;
	letter-spacing: 2px;
	font-size: .75rem;
	font-weight: 700
}

.value-card {
	background: #fff;
	border: 1px solid rgba(44, 74, 62, .09);
	border-radius: 20px
}

.value-icon {
	font-size: 1.8rem;
	color: var(--green)
}

.timeline-item {
	position: relative;
	padding-left: 3rem;
	padding-bottom: 2rem
}

.timeline-item:before {
	content: '';
	position: absolute;
	left: 10px;
	top: 0;
	width: 2px;
	height: 100%;
	background: #d9e5dc
}

.timeline-item:last-child:before {
	height: 28px
}

.timeline-dot {
	position: absolute;
	left: 0;
	top: 2px;
	width: 22px;
	height: 22px;
	border-radius: 50%;
	background: var(--green);
	border: 5px solid #dce9df
}

.cta {
	background: var(--green);
	color: #fff;
	border-radius: 24px
}

.btn-story {
	background: #fff;
	color: var(--green);
	border-radius: 50rem;
	font-weight: 700;
	padding: .75rem 1.4rem
}
</style>
</head>
<body>
	<jsp:include page="components/menuBar.jsp" />
	<main class="container py-4 py-md-5">
		<section class="story-hero p-4 p-md-5 mb-5">
			<div class="row align-items-center g-4">
				<div class="col-lg-7">
					<div class="eyebrow" data-en="OUR STORY" data-mm="ကျွန်ုပ်တို့၏ ဇာတ်လမ်း">OUR STORY</div>
					<h1 class="display-5 fw-bold mt-3"
						data-en="Good food should feel simple."
						data-mm="ကောင်းမွန်သော အစားအစာသည် ရိုးရှင်းနေသင့်သည်။">Good food should feel simple.</h1>
					<p class="lead text-secondary"
						data-en="Fresh Market was created around one idea: make it easier to discover and shop quality groceries in one friendly place."
						data-mm="Fresh Market ကို အတွေးအခေါ်တစ်ခုတည်းဖြင့် စတင်တည်ထောင်ခဲ့ပါသည်။ အရည်အသွေးကောင်း ကုန်စုံပစ္စည်းများကို နေရာတစ်ခုတည်းတွင် လွယ်ကူစွာ ရှာဖွေဝယ်ယူနိုင်စေရန် ဖြစ်ပါသည်။">Fresh Market was created around one idea: make it easier to discover and shop quality groceries in one friendly place.</p>
					<p class="text-secondary mb-0"
						data-en="We believe everyday shopping can be more convenient, more transparent, and more connected to the food people enjoy."
						data-mm="နေ့စဉ် ဈေးဝယ်ခြင်းသည် ပိုမိုအဆင်ပြေပြီး ပိုမိုပွင့်လင်းမြင်သာကာ လူအများ နှစ်သက်သော အစားအစာများနှင့် ပိုမိုနီးကပ်နိုင်သည်ဟု ကျွန်ုပ်တို့ ယုံကြည်ပါသည်။">We believe everyday shopping can be more convenient, more transparent, and more connected to the food people enjoy.</p>
				</div>
				<div class="col-lg-5">
					<div class="rounded-4 p-4 h-100"
						style="background: #2c4a3e; color: #fff">
						<div class="display-3">🌿</div>
						<h2 class="h4 mt-3"
							data-en="Fresh choices, every day."
							data-mm="နေ့စဉ် လတ်ဆတ်သော ရွေးချယ်မှုများ။">Fresh choices, every day.</h2>
						<p class="opacity-75 mb-0"
							data-en="A simple market experience built around the products people need."
							data-mm="လူအများ လိုအပ်သော ထုတ်ကုန်များကို အခြေခံ၍ တည်ဆောက်ထားသော ရိုးရှင်းသည့် ဈေးဝယ်အတွေ့အကြုံ။">A simple market experience built around the products people need.</p>
					</div>
				</div>
			</div>
		</section>

		<section class="row g-5 align-items-center mb-5">
			<div class="col-lg-6">
				<span class="eyebrow" data-en="WHY WE STARTED" data-mm="ကျွန်ုပ်တို့ စတင်ခဲ့ရခြင်း အကြောင်းရင်း">WHY WE STARTED</span>
				<h2 class="fw-bold mt-3"
					data-en="A market designed for modern everyday life."
					data-mm="ခေတ်ပြိုင် နေ့စဉ်ဘဝအတွက် ဒီဇိုင်းထုတ်ထားသော ဈေးတစ်ခု။">A market designed for modern everyday life.</h2>
				<p class="text-secondary"
					data-en="Shopping for groceries should not feel complicated. Fresh Market brings products, categories, and a simple shopping cart together in one place."
					data-mm="ကုန်စုံပစ္စည်း ဝယ်ယူခြင်းသည် ရှုပ်ထွေးနေစရာ မလိုပါ။ Fresh Market သည် ထုတ်ကုန်များ၊ အမျိုးအစားများနှင့် ရိုးရှင်းသော ဈေးခြင်းတောင်းကို နေရာတစ်ခုတည်းတွင် စုစည်းပေးထားပါသည်။">Shopping for groceries should not feel complicated. Fresh Market brings products, categories, and a simple shopping cart together in one place.</p>
				<p class="text-secondary mb-0"
					data-en="Our goal is to keep improving the experience while focusing on freshness, quality, and convenience."
					data-mm="လတ်ဆတ်မှု၊ အရည်အသွေးနှင့် အဆင်ပြေလွယ်ကူမှုတို့ကို အဓိကထားရင်း ဝန်ဆောင်မှုအတွေ့အကြုံကို ဆက်လက်တိုးတက်ကောင်းမွန်အောင် လုပ်ဆောင်သွားရန် ကျွန်ုပ်တို့၏ ရည်မှန်းချက် ဖြစ်ပါသည်။">Our goal is to keep improving the experience while focusing on freshness, quality, and convenience.</p>
			</div>
			<div class="col-lg-6">
				<div class="p-4 rounded-4"
					style="background: #fff; border: 1px solid rgba(44, 74, 62, .09)">
					<div class="row text-center g-3">
						<div class="col-4">
							<div class="fs-2 fw-bold" style="color: var(--green)">🌱</div>
							<div class="small fw-semibold" data-en="Freshness" data-mm="လတ်ဆတ်မှု">Freshness</div>
						</div>
						<div class="col-4">
							<div class="fs-2 fw-bold" style="color: var(--green)">🤝</div>
							<div class="small fw-semibold" data-en="Community" data-mm="အသိုက်အဝန်း">Community</div>
						</div>
						<div class="col-4">
							<div class="fs-2 fw-bold" style="color: var(--green)">✓</div>
							<div class="small fw-semibold" data-en="Quality" data-mm="အရည်အသွေး">Quality</div>
						</div>
					</div>
				</div>
			</div>
		</section>

		<section class="mb-5">
			<div class="text-center mb-4">
				<span class="eyebrow" data-en="OUR VALUES" data-mm="ကျွန်ုပ်တို့၏ တန်ဖိုးထားမှုများ">OUR VALUES</span>
				<h2 class="fw-bold mt-3"
					data-en="What guides Fresh Market"
					data-mm="Fresh Market ကို လမ်းညွှန်ပေးသော အရာများ">What guides Fresh Market</h2>
			</div>
			<div class="row g-3">
				<div class="col-md-3">
					<div class="value-card p-4 h-100">
						<i class="bi bi-basket2-fill value-icon"></i>
						<h3 class="h5 mt-3" data-en="Freshness" data-mm="လတ်ဆတ်မှု">Freshness</h3>
						<p class="text-secondary mb-0"
							data-en="Products selected to support better everyday meals."
							data-mm="နေ့စဉ် အစားအစာများ ပိုမိုကောင်းမွန်စေရန် ရွေးချယ်ထားသော ထုတ်ကုန်များ။">Products selected to support better everyday meals.</p>
					</div>
				</div>
				<div class="col-md-3">
					<div class="value-card p-4 h-100">
						<i class="bi bi-patch-check-fill value-icon"></i>
						<h3 class="h5 mt-3" data-en="Quality" data-mm="အရည်အသွေး">Quality</h3>
						<p class="text-secondary mb-0"
							data-en="Clear product information and thoughtful choices."
							data-mm="ရှင်းလင်းသော ထုတ်ကုန်အချက်အလက်များနှင့် ဂရုတစိုက် ရွေးချယ်မှုများ။">Clear product information and thoughtful choices.</p>
					</div>
				</div>
				<div class="col-md-3">
					<div class="value-card p-4 h-100">
						<i class="bi bi-people-fill value-icon"></i>
						<h3 class="h5 mt-3" data-en="Community" data-mm="အသိုက်အဝန်း">Community</h3>
						<p class="text-secondary mb-0"
							data-en="A market experience that puts people and everyday needs first."
							data-mm="လူအများနှင့် နေ့စဉ်လိုအပ်ချက်များကို ဦးစားပေးသော ဈေးဝယ်အတွေ့အကြုံ။">A market experience that puts people and everyday needs first.</p>
					</div>
				</div>
				<div class="col-md-3">
					<div class="value-card p-4 h-100">
						<i class="bi bi-recycle value-icon"></i>
						<h3 class="h5 mt-3" data-en="Responsibility" data-mm="တာဝန်ယူမှု">Responsibility</h3>
						<p class="text-secondary mb-0"
							data-en="We aim to keep improving how we manage products and shopping."
							data-mm="ထုတ်ကုန်များနှင့် ဈေးဝယ်စနစ်ကို စီမံခန့်ခွဲပုံအား ဆက်လက်တိုးတက်ကောင်းမွန်အောင် ကျွန်ုပ်တို့ ရည်မှန်းထားပါသည်။">We aim to keep improving how we manage products and shopping.</p>
					</div>
				</div>
			</div>
		</section>

		<section class="row g-5 mb-5">
			<div class="col-lg-6">
				<span class="eyebrow" data-en="OUR JOURNEY" data-mm="ကျွန်ုပ်တို့၏ ခရီးစဉ်">OUR JOURNEY</span>
				<h2 class="fw-bold mt-3"
					data-en="Growing step by step."
					data-mm="တစ်ဆင့်ချင်းစီ တိုးတက်ကြီးထွားလာခြင်း။">Growing step by step.</h2>
			</div>
			<div class="col-lg-6">
				<div class="timeline-item">
					<span class="timeline-dot"></span>
					<strong data-en="2026 — The idea takes shape" data-mm="၂၀၂၆ — စိတ်ကူးပုံပေါ်လာခြင်း">2026 — The idea takes shape</strong>
					<p class="text-secondary mb-0"
						data-en="Fresh Market begins as an online grocery shopping project."
						data-mm="Fresh Market သည် အွန်လိုင်း ကုန်စုံဈေးဝယ် ပရောဂျက်တစ်ခုအဖြစ် စတင်ခဲ့ပါသည်။">Fresh Market begins as an online grocery shopping project.</p>
				</div>
				<div class="timeline-item">
					<span class="timeline-dot"></span>
					<strong data-en="Today — Building a better market" data-mm="ယနေ့ — ပိုမိုကောင်းမွန်သော ဈေးတစ်ခုကို တည်ဆောက်ခြင်း">Today — Building a better market</strong>
					<p class="text-secondary mb-0"
						data-en="Products, categories, cart management, orders, and payments come together."
						data-mm="ထုတ်ကုန်များ၊ အမျိုးအစားများ၊ ဈေးခြင်းတောင်း စီမံခန့်ခွဲမှု၊ အော်ဒါများနှင့် ငွေပေးချေမှုများကို ပေါင်းစပ်ထားပါသည်။">Products, categories, cart management, orders, and payments come together.</p>
				</div>
				<div class="timeline-item">
					<span class="timeline-dot"></span>
					<strong data-en="Next — Keep growing" data-mm="ရှေ့ဆက် — ဆက်လက်တိုးတက်ကြီးထွားခြင်း">Next — Keep growing</strong>
					<p class="text-secondary mb-0"
						data-en="More products, better experiences, and continued improvements."
						data-mm="ထုတ်ကုန်များ ပိုမိုစုံလင်လာခြင်း၊ ပိုကောင်းသော အတွေ့အကြုံများနှင့် ဆက်လက်တိုးတက်မှုများ။">More products, better experiences, and continued improvements.</p>
				</div>
			</div>
		</section>

		<section class="cta p-4 p-md-5 text-center">
			<h2 class="fw-bold"
				data-en="Thanks for being part of our story."
				data-mm="ကျွန်ုပ်တို့ ဇာတ်လမ်း၏ အစိတ်အပိုင်းတစ်ခုအဖြစ် ပါဝင်ပေးသည့်အတွက် ကျေးဇူးတင်ပါသည်။">Thanks for being part of our story.</h2>
			<p class="opacity-75"
				data-en="Explore the latest products and see what Fresh Market has to offer."
				data-mm="နောက်ဆုံးရ ထုတ်ကုန်များကို ကြည့်ရှုပြီး Fresh Market တွင် ရရှိနိုင်သည်များကို လေ့လာကြည့်ပါ။">Explore the latest products and see what Fresh Market has to offer.</p>
			<a class="btn btn-story"
				href="${pageContext.request.contextPath}/home"
				data-en="Shop Fresh Products"
				data-mm="လတ်ဆတ်သော ကုန်ပစ္စည်းများကို ဝယ်ယူပါ">Shop Fresh Products <i class="bi bi-arrow-right ms-1"></i></a>
		</section>
	</main>
	<script
		src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>