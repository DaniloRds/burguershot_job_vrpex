$(function() {
	init();

	function formatMoney(n, c, d, t) {
		c = isNaN(c = Math.abs(c)) ? 2 : c, d = d == undefined ? "," : d, t = t == undefined ? "." : t, s = n < 0 ? "-" : "", i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
		return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t);
	  }
  
	var actionContainer = $(".actionmenu");
  
	window.addEventListener("message", function(event) {
	  var item = event.data;
	  var ingrediente = document.getElementById('num_ingrediente')
	  var hamburguer = document.getElementById('num_hamburguer')
	  var hotdog = document.getElementById('num_hotdog')
	  var pizza = document.getElementById('num_pizza')
	  var frango = document.getElementById('num_frango')
	  var bebidas = document.getElementById('num_bebidas')
	  var dinheiro = document.getElementById('num_dinheiro')
  
	  if (item.showmenu) {
		ResetMenu();
		$('body').css('background-color', 'rgba(0, 0, 0, 0.15)')
		actionContainer.fadeIn();
	  }
  
	  if (item.hidemenu) {
		$('body').css('background-color', 'transparent')
		actionContainer.fadeOut();
	  }

	  switch(event.data.action){
		case "showMenu":
			ingrediente.textContent = item.ingredientes;
			hamburguer.textContent = item.hamburguer;
			hotdog.textContent = item.hotdog;
			pizza.textContent = item.pizza;
			frango.textContent = item.frango;
			bebidas.textContent = item.bebidas;
			dinheiro.textContent = "R$" + formatMoney(item.dinheiro);
		break;
		}

	});
  
	document.onkeyup = function(data) {
	  if (data.which == 27) {
		if (actionContainer.is(":visible")) {
		  sendData("ButtonClick", "fechar");
		}
	  }
	};
  });
  
  function ResetMenu() {
	$("div").each(function(i, obj) {
	  var element = $(this);
  
	  if (element.attr("data-parent")) {
		element.hide();
	  } else {
		element.show();
	  }
	});
  }
  
  function init() {
	$(".menuoption").each(function(i, obj) {
	  if ($(this).attr("data-action")) {
		$(this).click(function() {
		  var data = $(this).data("action");
		  sendData("ButtonClick", data);
		});
	  }
  
	  if ($(this).attr("data-sub")) {
		var menu = $(this).data("sub");
		var element = $("#" + menu);
  
		$(this).click(function() {
		  element.show();
		  $("#mainmenu").hide();
		});
  
		$(".subtop button, .back").click(function() {
		  element.hide();
		  $("#mainmenu").show();
		});
	  }
	});
  }
  
  function sendData(name, data) {
	$.post("http://nui_gerenciamento/" + name, JSON.stringify(data), function(
	  datab
	) {
	  if (datab != "ok") {
		console.log(datab);
	  }
	});
  }
  

$(document).on("click","#sacar", function() {
	$.post("http://nui_gerenciamento/sacar");
	$.post("http://nui_gerenciamento/close");
});

$(document).on("click","#depositar", function() {
	$.post("http://nui_gerenciamento/depositar");
	$.post("http://nui_gerenciamento/close");
});

$(document).on("click","#contratar", function() {
	$.post("http://nui_gerenciamento/contratar");
	$.post("http://nui_gerenciamento/close");
});

$(document).on("click","#demitir", function() {
	$.post("http://nui_gerenciamento/demitir");
	$.post("http://nui_gerenciamento/close");
});

$(document).on("click","#lista_funcionarios", function() {
	$.post("http://nui_gerenciamento/funcionarios");
	$.post("http://nui_gerenciamento/close");
});

