#
# copy from ui.bootstrap
#
angular.module("ui.bootstrap",[]).directive('collapse',[
  '$animate'
  ($animate)->
    expand = (elem)->
      
      elem.removeClass("collapse")
      .addClass('collapsing')
      $animate.addClass(elem,'in',{
        to:{height:elem[0].scrollHeight + "px"}
      }).then(()->
        expandDone(elem)
      );

    expandDone = (elem)->
      elem.removeClass('collapsing');
      elem.css({height:"auto"});

    collapse = (elem)->
      if elem.hasClass('collapse') and !elem.hasClass("in")
        return collapseDone(elem)
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
    collapseDone = (elem)->
      elem.css({height:'0'}).removeClass("collapsing").addClass("collapse")
    return {
      link:(scope,elem,attrs)->

        model = attrs.model || 'auto'


        scope.$watch(attrs.collapse,(shouldCollapse)->
          if shouldCollapse
            collapse(elem)
          else
            expand(elem)
        )

    }
])