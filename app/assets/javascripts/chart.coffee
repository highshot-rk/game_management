# function initGoogleChart() {
#   if (!google.visualization) {
#     google.load("visualization", "1", {packages:["corechart"]});
#     google.setOnLoadCallback(drawCharts);
#     console.log("Loading charts");
#   } else {
#     drawCharts();
#     console.log("Drawing charts");
#   }
# }
# initGoogleChart();

showCharts = ->
  $('[data-chart]').each ->
    $this = $(this)
    method = $this.attr('data-chart')
    window[method](this)

initGoogleChart = ->
  if !window.google.visualization
    window.google.charts.load('current', {packages: ['corechart']})
    window.google.charts.setOnLoadCallback(showCharts)
  else
    showCharts()

ensureGoogleChart = ->
  if ($('[data-chart]').length > 0)
    if !window.google
      $.ajax({
          url: 'https://www.gstatic.com/charts/loader.js',
          dataType: 'script',
          cache: true,
          success: initGoogleChart
      });
    else
      initGoogleChart()

$(document).ready(ensureGoogleChart)
$(document).on 'pjax:success', ensureGoogleChart
