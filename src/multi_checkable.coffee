get = (object, key) ->
  return undefined unless object
  return object    unless key
  object.get?(key) or object[key]

set = (object, key, value) ->
  return unless object and key
  object.set?(key, value) or object[key] = value


Ember.Widgets.SelectableItem = Ember.Object.extend
  label: undefined
  value: undefined
  selected: undefined


Ember.Widgets.MultiCheckableComponent = Ember.Widgets.MultiSelectComponent.extend
  selections: []
  templateName: 'multi-checkable'
  selectableItems: Ember.computed ->
    hash = @get 'content'
    hash.map (item) =>
      label = get item, @get('optionLabelPath')
      value = get item, @get('optionValuePath')
      selected = item in @get('selections')

      emberized = Ember.Object.create
        label: label
        value: value
      emberized.set @get('optionLabelPath'), label
      emberized.set @get('optionValuePath'), value
      emberized.set "selected", selected
      emberized
  .property 'content.@each'

  thingobserver: Ember.observer ->
    @set "selections", @get("selectableItems").filter (item) ->
      item.get "selected"
  , 'selectableItems.@each.selected'

  filteredItemControllers: Ember.computed ->
    Ember.ArrayController.create
      content: @get 'filteredItems'
  .property 'filteredItems.@each', 'query'

  # the list of content that is filtered down based on the query entered
  # in the textbox
  filteredItems: Ember.computed ->
    selectableItems = @get 'selectableItems'
    query   = @get 'query'
    return selectableItems unless query
    # don't exclude items that are already selected
    @get('selectableItems').filter (item) =>
      @matcher(query, item)
  .property 'selectableItems.@each', 'query'

  actions:
    toggle: (item) ->
      selections = @get 'selections'
      if item and not selections.contains item
        selections.pushObject item
      else if selections.contains item
        selection.removeObject item