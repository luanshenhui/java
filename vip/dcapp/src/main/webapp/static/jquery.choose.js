+function ($) {

    var Choose = function (element, options) {

        var _default = {};

        this.$element = $(element);

        this.options = $.extend({}, _default, options);

        this.obj = {};

        _event.call(this);

    };


    function _event() {

        var $this = this;

        this.$element.on('loaded', function () {

            _reverse.call($this)

        })

            .on('click', 'input[type="checkbox"]', function () {

                var _state = $(this).prop("checked"),

                    _val = $(this).val();

                if (_state == true) {

                    $this.obj[_val] = 1;

                } else {

                    delete $this.obj[_val]

                }

            })

            .on('change', function () {

                _reverse.call($this)

            });

        this.load()


    }

    function _reverse() {

        var $this = this;

        $('input[type="checkbox"]', this.$element).each(function () {

            $this.obj[$(this).val()] && $(this).prop('checked', true);

        })


    }

    Choose.prototype.load = function () {
    	
    	console.info('=====>',this.options.params)

        var $this = this;

        this.$element.trigger('load');

        this.$element.load(this.options.url,this.options.params||{}, function () {

            $this.$element.trigger('loaded');

        })

    };

    Choose.prototype.getValue = function (fn) {

         fn && fn(Object.keys(this.obj))

    };

    Choose.prototype.setValue = function (obj) {

        var $this = this;

        $.each(obj, function (i, data) {

            $this.obj[data] = 1

        });

        _reverse.call(this)

    };

    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1);

        return this.each(function () {

            var $this = $(this);

            var data = $this.data('by.choose');

            var options = typeof option == 'object' && option;

            if (!data) {

                $this.data('by.choose', (data = new Choose(this, options)))

            }

            if (typeof option == 'string') {

                data[option].apply(data, args)

            }

            return data;

        })

    }

    var old = $.fn.choose;

    $.fn.choose = Plugin;

    $.fn.choose.Constructor = Choose;

    $.fn.choose.noConflict = function () {

        $.fn.choose = old;

        return this

    }

}(jQuery);