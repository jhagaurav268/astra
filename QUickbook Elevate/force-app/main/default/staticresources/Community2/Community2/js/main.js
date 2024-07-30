/*******************************************************************************

	Title: Js Framework
	Author: Mohamed Azzam

*******************************************************************************/

(function($) {

	var App = {

		/**
		 * Init Function
		 */
		init: function() {
			App.action();
			App.Tabs();
			App.popup();
		},
		
		/**
		 * Custom Form Style
		 */
		action: function() {
		
	
			$('.action_box > li.test').hover(function () {
				$('.act_in').stop().slideDown("slow");
			}, function(){
				$('.act_in').stop().slideUp("slow");
			});

		},
		
		Tabs:function(){
						$('ul.nav').each(function(){
    var $active, $content, $links = $(this).find('a');
    $active = $($links.filter('[href="'+location.hash+'"]')[0] || $links[0]);
    $active.addClass('active');
    $content = $($active[0].hash);
    $links.not($active).each(function () {
      $(this.hash).hide();
    });

    $(this).on('click', 'a', function(e){
      $active.removeClass('active');
      $content.hide();
      $active = $(this);
      $content = $(this.hash);
      $active.addClass('active');
      $content.show();
      e.preventDefault();
    });
  });
		},
		
		
		popup: function(){
			$('.fancybox').fancybox();
	},

	}
	
	
	
	$(function() {
		App.init();
	});

})(jQuery);

