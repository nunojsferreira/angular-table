class Table

  constructor: (@element, @table_configuration) ->

  constructHeader: () ->
    tr = angular.element(document.createElement("tr"))
    for i in @table_configuration.column_configurations
      tr.append(i.render_html())
    return tr

  setup_header: () ->
    thead = @element.find("thead")
    if thead
      header = @constructHeader()
      tr = angular.element(thead).find("tr")
      tr.remove()
      thead.append(header)

  get_setup: () ->
    if @table_configuration.paginated
      return new PaginatedSetup(@table_configuration)
    else
      return new StandardSetup(@table_configuration)
    return

  compile: () ->
    @setup_header()
    @setup = @get_setup()
    @setup.compile(@element)

  setup_initial_sorting: ($scope) ->
    for bd in @table_configuration.column_configurations
      if bd.initialSorting
        throw "initial-sorting specified without attribute." if not bd.attribute
        $scope.predicate = bd.attribute
        $scope.descending = bd.initialSorting == "desc"

  post: ($scope, $element, $attributes, $filter) ->
    @setup_initial_sorting($scope)

    $scope.getSortIcon = (predicate) ->
      return "icon-minus" if predicate != $scope.predicate
      if $scope.descending then "icon-chevron-down" else "icon-chevron-up"

    @setup.link($scope, $element, $attributes, $filter)