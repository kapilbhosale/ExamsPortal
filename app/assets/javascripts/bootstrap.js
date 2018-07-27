var $j = jQuery.noConflict();
$j(function() {
  $j("a[rel~=popover], .has-popover").popover();
  $j("a[rel~=tooltip], .has-tooltip").tooltip();
});
