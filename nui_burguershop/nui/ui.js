$(function() {
	init();
  
	var actionContainer = $(".actionmenu");
  
	window.addEventListener("message", function(event) {
	  var item = event.data;
	  var hotdog = document.getElementById('qntHotdog')
	  var hamburguer = document.getElementById('qntHam')
	  var pizza = document.getElementById('qntPizza')
	  var frango = document.getElementById('qntFrango')
	  var agua = document.getElementById('qntBebidas')
	  var cola = document.getElementById('qntBebidas2')
  
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
		case "atualizar":
			hotdog.textContent = item.hotdog;
			hamburguer.textContent = item.hamburguer;
			pizza.textContent = item.pizza;
			frango.textContent = item.frango;
			agua.textContent = item.agua;
			cola.textContent = item.cola;
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
	$.post("http://nui_burguershop/" + name, JSON.stringify(data), function(
	  datab
	) {
	  if (datab != "ok") {
		console.log(datab);
	  }
	});
  }
  
  $('.category_arma').click(function() {
	let pegArma = $(this).attr('category');
	$('.arma-item').css('transform', 'scale(0)');
  
	function hideArma() {
		$('.arma-item').hide();
	}
	setTimeout(hideArma, 100);
  
	function showArma() {
		$('.arma-item[category="' + pegArma + '"]').show();
		$('.arma-item[category="' + pegArma + '"]').css('transform', 'scale(1)');
	}
	setTimeout(showArma, 100);
  });
  
  $('.category_arma[category="all"]').click(function() {
	function showAll() {
		$('.arma-item').show();
		$('.arma-item').css('transform', 'scale(1)');
	}
	setTimeout(showAll, 100);
  });