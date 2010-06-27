/*
 * jquery.tools 1.1.2 - The missing UI library for the Web
 * 
 * [tools.expose-1.0.5]
 * 
 * Copyright (c) 2009 Tero Piirainen
 * http://flowplayer.org/tools/
 *
 * Dual licensed under MIT and GPL 2+ licenses
 * http://www.opensource.org/licenses
 * 
 * -----
 * 
 * File generated: Wed Oct 07 12:00:36 GMT+00:00 2009
 */
(function(b){b.tools=b.tools||{};b.tools.expose={version:"1.0.5",conf:{maskId:null,loadSpeed:"slow",closeSpeed:"fast",closeOnClick:true,closeOnEsc:true,zIndex:9998,opacity:0.8,color:"#456",api:false}};function a(){if(b.browser.msie){var f=b(document).height(),e=b(window).height();return[window.innerWidth||document.documentElement.clientWidth||document.body.clientWidth,f-e<20?e:f]}return[b(window).width(),b(document).height()]}function c(h,g){var e=this,j=b(this),d=null,f=false,i=0;b.each(g,function(k,l){if(b.isFunction(l)){j.bind(k,l)}});b(window).resize(function(){e.fit()});b.extend(this,{getMask:function(){return d},getExposed:function(){return h},getConf:function(){return g},isLoaded:function(){return f},load:function(n){if(f){return e}i=h.eq(0).css("zIndex");if(g.maskId){d=b("#"+g.maskId)}if(!d||!d.length){var l=a();d=b("<div/>").css({position:"absolute",top:0,left:0,width:l[0],height:l[1],display:"none",opacity:0,zIndex:g.zIndex});if(g.maskId){d.attr("id",g.maskId)}b("body").append(d);var k=d.css("backgroundColor");if(!k||k=="transparent"||k=="rgba(0, 0, 0, 0)"){d.css("backgroundColor",g.color)}if(g.closeOnEsc){b(document).bind("keydown.unexpose",function(o){if(o.keyCode==27){e.close()}})}if(g.closeOnClick){d.bind("click.unexpose",function(o){e.close(o)})}}n=n||b.Event();n.type="onBeforeLoad";j.trigger(n);if(n.isDefaultPrevented()){return e}b.each(h,function(){var o=b(this);if(!/relative|absolute|fixed/i.test(o.css("position"))){o.css("position","relative")}});h.css({zIndex:Math.max(g.zIndex+1,i=="auto"?0:i)});var m=d.height();if(!this.isLoaded()){d.css({opacity:0,display:"block"}).fadeTo(g.loadSpeed,g.opacity,function(){if(d.height()!=m){d.css("height",m)}n.type="onLoad";j.trigger(n)})}f=true;return e},close:function(k){if(!f){return e}k=k||b.Event();k.type="onBeforeClose";j.trigger(k);if(k.isDefaultPrevented()){return e}d.fadeOut(g.closeSpeed,function(){k.type="onClose";j.trigger(k);h.css({zIndex:b.browser.msie?i:null})});f=false;return e},fit:function(){if(d){var k=a();d.css({width:k[0],height:k[1]})}},bind:function(k,l){j.bind(k,l);return e},unbind:function(k){j.unbind(k);return e}});b.each("onBeforeLoad,onLoad,onBeforeClose,onClose".split(","),function(k,l){e[l]=function(m){return e.bind(l,m)}})}b.fn.expose=function(d){var e=this.eq(typeof d=="number"?d:0).data("expose");if(e){return e}if(typeof d=="string"){d={color:d}}var f=b.extend({},b.tools.expose.conf);d=b.extend(f,d);this.each(function(){e=new c(b(this),d);b(this).data("expose",e)});return d.api?e:this}})(jQuery);
