$(document).ready(function(){
  $('.paper-tab-base').click(function(tabEvent) {
    $('.paper-tab-base').removeClass('paper-tab-base-clicked');
    $targetTab = $(tabEvent.target);
    $targetTab.addClass('paper-tab-base-clicked');
    targetedPageSelector = '.' + $targetTab.data('target-buttons');
    targetedHidePageSelector = 'div:not(' + targetedPageSelector + ').teudu-page';
    $(targetedPageSelector).show();
    $(targetedHidePageSelector).hide();
  });
});
