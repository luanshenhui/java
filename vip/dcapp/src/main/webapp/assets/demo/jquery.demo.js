/**
 * jquery书写demo
 */




+(function ($) {

    /**
     *
     * @param element dom节点
     * @param options  options 参数
     * @constructor
     */
    function Demo(element, options) {

        this.$element = $(element)

        this.options = $.extend({}, {

            msg: "你好!"

        }, options);


        _buildEvent.call(this);

        console.info('==========')

    }

    function _buildEvent() {

        var $this = this;

        this.$element

            .on('click', '.start', function () {

                console.info('========>', $this.options.msg);

                // $this.start();
                _load()
            })

            .on('click', '.end', function (e) {

                console.info(this, $(this).text());

                console.info("--1---")

                var a = $(e.delegateTarget).trigger('end');

                console.info('---2--', a)


            })

            .on('end', function () {

                console.info('=====event end========',arguments)


                return false;
            })

    }


    /**
     * 私有方法
     * @private
     */
    function _load() {

        console.info('---------private===>')
    }


    /**
     * public 方法
     */
    Demo.prototype.start = function (arg1, arg2, arg3) {

        console.info('========public start========>', arg1, arg2, arg3)

    }


    // ========================

    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1)

        return this.each(function () {
            var $this = $(this);
            var data = $this.data('dcapp.demo')
            var options = typeof option == 'object' && option

            if (!data) {
                $this.data('dcapp.demo', (data = new Demo(this, options)))
            }

            if (typeof option == 'string') {

                data[option].apply(data, args)
            }
        })
    }

    var old = $.fn.demo1;

    $.fn.demo1 = Plugin;
    $.fn.demo1.Constructor = Demo;

    // ==================

    $.fn.demo1.noConflict = function () {
        $.fn.demo1 = old;
        return this
    }


})(jQuery);


$(function () {

    console.info(1)

    $('#demo').demo1({
        msg: "hello"
    })


    // $('#demo').demo1("start", 1, 2, 3)

})

