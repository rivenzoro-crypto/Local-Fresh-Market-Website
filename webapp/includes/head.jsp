<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fresh Market — Admin</title>
<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<style>
:root{--sidebar-width:260px;--lux-bg:#F8FAF8;--lux-sidebar:#0B130E;--lux-emerald:#1B4332;--lux-emerald-light:#2D6A4F;--lux-gold:#D4AF37;--lux-card-bg:#fff;--lux-border:rgba(11,19,14,.07);--lux-text-primary:#1A1D1A;--lux-text-muted:#717A74}
body{font-family:'Plus Jakarta Sans',sans-serif;background:var(--lux-bg);color:var(--lux-text-primary)}#sidebar{width:var(--sidebar-width);height:100vh;position:fixed;top:0;left:0;z-index:1040;transition:.3s;background:var(--lux-sidebar);border-right:1px solid rgba(255,255,255,.05)}#content{margin-left:var(--sidebar-width);min-height:100vh}.lux-card{background:#fff;border:1px solid var(--lux-border);border-radius:16px;box-shadow:0 4px 20px -2px rgba(11,19,14,.03)}.metric-card{transition:transform .2s,box-shadow .2s}.metric-card:hover{transform:translateY(-3px);box-shadow:0 10px 25px rgba(11,19,14,.08)}.page-kicker{font-size:.72rem;letter-spacing:1.4px;text-transform:uppercase;color:var(--lux-text-muted);font-weight:700}.status-badge{text-transform:capitalize;font-size:.72rem}.empty-state{padding:2.5rem 1rem;text-align:center;color:var(--lux-text-muted)}
.btn{font-weight:600}.form-control,.form-select{border-radius:10px}.form-control:focus,.form-select:focus{border-color:#6b9b7d;box-shadow:0 0 0 .2rem rgba(27,67,50,.10)}
:focus-visible{outline:3px solid rgba(212,175,55,.65);outline-offset:2px}
.table thead th{font-weight:700;white-space:nowrap}.table tbody td{vertical-align:middle}.card-header{border-top-left-radius:16px!important;border-top-right-radius:16px!important}.btn{transition:transform .15s ease,box-shadow .15s ease}.btn:active{transform:translateY(1px)}.admin-page-title{font-weight:800;letter-spacing:-.03em}.lux-card{overflow:hidden}.form-label{margin-bottom:.45rem}
@media(max-width:575.98px){.navbar{padding-inline:1rem!important}#content main{padding-inline:1rem!important}.lux-card{border-radius:13px}}
@media(max-width:991.98px){#sidebar{margin-left:calc(-1 * var(--sidebar-width))}#sidebar.active{margin-left:0}#content{margin-left:0}.admin-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.35);z-index:1030}.admin-overlay.show{display:block}}
</style>
</head>
