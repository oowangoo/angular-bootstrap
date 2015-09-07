#
# copy from ui.bootstrap
#
angular.module("ui.bootstrap",[]).directive('collapse',[
  '$window'
  '$animate'
  ($window,$animate)->

    removeAnimateClass = (elem)->
      return elem.removeClass('collapsing collapsing-h');

    addAnimateClass = (elem,option)->
      switch(option.align)
        when 'left'
          c = 'collapsing-h'
        else
          # top
          c = "collapsing"
      return elem.addClass(c)
    getOptionWidth = (elem,option)->
      switch(option.model)
        when 'full'
          w = $window.innerWidth
        else
          w = elem[0].scrollWidth
      return (w - option.offset)

    getOptionHeight = (elem,option)->
      switch(option.model)
        when 'full'
          h = $window.innerHeight
        else
          h = elem[0].scrollHeight
      return h - option.offset

    expand = (elem,option)->
      elem.removeClass("collapse")
      addAnimateClass(elem,option).addClass('collapsing')
      switch(option.align)
        when 'left'
          to = {to:{width:getOptionWidth(elem,option)+'px'}}
        else
          to = {to:{height:getOptionHeight(elem,option)+'px'}}

      $animate.addClass(elem,'in',to).then(()->
        expandDone(elem,option)
      );

    expandDone = (elem，option)->
      removeAnimateClass(elem)
      switch(option.model)
        when 'full'
          ;
        else
          switch(option.align)
            when 'left'
              elem.css({width:'auto'})
            else
              elem.css({heigh:'auto'})

    collapse = (elem,option)->
      if elem.hasClass('collapse') and !elem.hasClass("in")
        return collapseDone(elem,option)
#      IMPORTANT: The height must be set before adding "collapsing" class.
#      Otherwise, the browser attempts to animate from height 0 (in
#      collapsing class) to the given height here.
      elem.css({height:element[0].scrollHeight + 'px'})
        .removeClass('collapse')
        .addClass("collapsing")
      $animate.removeClass(elem,'in',{
        to:{height:"0"}
      }).then(()->
        collapseDone(elem)
      )

    collapseDone = (elem,option)->
      switch(option.align)
        when 'left'
          elem.css({width:'0'})
        else
          elem.css({heigh:'0'})

      removeAnimateClass(elem)
      elem.addClass("collapse")

    return {
      link:(scope,elem,attrs)->

        model = attrs.fillModel || 'auto'
        offset = attrs.collapseOffset || 0
        align = attrs.collapseAlign || 'top'

        option = {
          model
          offset
          align
        }

        scope.$watch(attrs.collapse,(shouldCollapse)->
          if shouldCollapse
            collapse(elem,option)
          else
            expand(elem,option)
        )

    }
])