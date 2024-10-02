$(document).ready(function(){
	let actionContainer = $("body");
	let actionButton = $("#actionbutton");

	window.addEventListener("message",function(event){
	var item = event.data;
	var teste = document.getElementById('numing')

		switch(event.data.action){
			case "showMenu":
				actionContainer.fadeIn(500);
				teste.textContent = item.ingredientes;
			break;

			case "hideMenu":
				actionContainer.fadeOut(500);
			break;

			case 'carrosList':
				carrosList();
			break;
		}
	});

	$("#inicio").load("./inicio.html");

	document.onkeyup = function(data) {
		if (data.which == 27){
			$.post("http://nui_cozinha/shopClose");
		}
	};
});

$('#fechar').click(function(e){
	$.post("http://nui_cozinha/shopClose");
});

const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}

const carregarMenu = (name) => {
	return new Promise((resolve) => {
		$("#inicio").load(name+".html",function(){
			resolve();
		});
	});
}

const itensList = () => {
	$.post("http://nui_cozinha/itensList",JSON.stringify({}),(data) => {
		let i = 0;
		const nameList = data.shopitens.sort((a,b) => (a.name > b.name) ? 1: -1);
		
		$('#inicio').html(`
			${nameList.map((item) => (`
				<div class="model" data-index-key="${item.index}">
					<div class="name">${item.name}</div>
					<div class="imagem-carro"><img src="${item.img}"/></div>
					<img class="comprar" src="https://cdn.discordapp.com/attachments/452891038349262849/832169355692867634/touch.png"></img>
				</div>
			`)).join('')}
		`);
	});
}

$(document).on("click",".model", function() {
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('.model').removeClass('active');
	if(!isActive) $el.addClass('active');
});

$(document).on("click",".comprar", function() {
	let $el = $('.model:hover');
	let type = $(this).data('cat');
	if($el.length) {
		var arr = { index: $el.attr('data-index-key'), type: type, buy: "buy" };
		$.post("http://nui_cozinha/shopBuy",JSON.stringify(arr));
	}
});

$(document).on("click","#humburger", function() {
	$.post("http://nui_cozinha/humburger");
	$.post("http://nui_cozinha/shopClose");
});

$(document).on("click","#pizza", function() {
	$.post("http://nui_cozinha/pizza");
	$.post("http://nui_cozinha/shopClose");
});

$(document).on("click","#hotdog", function() {
	$.post("http://nui_cozinha/hotdog");
	$.post("http://nui_cozinha/shopClose");
});

$(document).on("click","#frango", function() {
	$.post("http://nui_cozinha/frango");
	$.post("http://nui_cozinha/shopClose");
});

$('#inictio').click(() => {
	$("#inicio").load("./inicio.html");
});

$('#receitas').click(() => {
    $('.container-infos').hide();
	$('.container-receitas').show();
});

$('.img-restaurante').click(() => {
    $('.container-infos').show();
	$('.container-receitas').hide();
});

$('#inictio').click(() => {
    $('.container-infos').show();
	$('.container-receitas').hide();
});


$(document).on("click",".comprar", function() {
	let $el = $('.model:hover');
	let type = $(this).data('cat');
	if($el.length) {
		var arr = { index: $el.attr('data-index-key'), type: type, buy: "buy" };
		$.post("http://nui_cozinha/shopItem",JSON.stringify(arr));
	}
});