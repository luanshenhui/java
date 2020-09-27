+function ($) {

    var Autocompleter = function (element, options) {

        var _default = {};

        this.$default = $(element);

        this.options = $.extend({}, _default, options);

        this.data = [];

        _createElement.call(this);

        _event.call(this);

    };

    function _createElement() {

        this.$default.wrap('<div data-role="selectBox" class="auto-completer">').after('<ul data-role="selectList">');

        this.$element = this.$default.parents('div[data-role="selectBox"]');

    }

    function _style() {

        var _top = +(this.$default.height()) + 1;

        $('ul[data-role="selectList"]', this.$element).css('top', _top);

    }

    function _event() {

        var $this = this;

        this.$element.on('keyup', this.$default, function (e) {

            e.stopPropagation();

            _load.call($this);

        })
            .on('click', 'ul[data-role="selectList"]>li', function (e) {

                e.stopPropagation();

                var liText = $(this).text();

                $this.$default.val(liText);

                $('ul[data-role="selectList"]', $this.$element).slideUp(500);

            });

        $(document).on('click', function (e) {

            $('ul[data-role="selectList"]', $this.$element).slideUp(500);

        })

    }

    function _load() {

        var $this = this,

            _li = '';


        if (this.options.data && !this.options.url) {

            $this.data = $this.options.data;

        }

       else if (!this.options.data && this.options.url) {

            $.getJSON($this.options.url, function (data) {

                $this.data = data

            });

        }

       else {

            $.getJSON($this.options.url, function (data) {

                $this.data = data

            });

        }

        boxVal = this.$default.val();

        $('ul[data-role="selectList"]', $this.$element).empty();

        $.each($this.data, function (i, data) {

            if ($this.options.model == 'begin') {

                if (data.keyVal.indexOf(boxVal) == 0 && (boxVal != '')) {

                    _li = $('<li data-value="' + data.keyVal + '">').text(data.keyVal);

                    _style.call($this);

                    $('ul[data-role="selectList"]', $this.$element).append(_li).slideDown(200);

                }
            } else {

                if (data.keyVal.indexOf(boxVal) > -1 && (boxVal != '')) {

                    _li = $('<li data-value="' + data.keyVal + '">').text(data.keyVal);

                    _style.call($this);

                    $('ul[data-role="selectList"]', $this.$element).append(_li).slideDown(200);

                }


            }

        });

        if (!$this.$default.val()) {

            $('ul[data-role="selectList"]', $this.$element).empty().slideUp(200);

        }

    }

    Autocompleter.prototype.getValue = function (fn) {

        var $this = this,

            boxVal = this.$default.val();

        fn && fn(boxVal)

    };

    function Plugin(option) {

        var args = Array.prototype.slice.call(arguments, 1);

        return this.each(function () {

            var $this = $(this);

            var data = $this.data('by.autocompleter');

            var options = typeof option == 'object' && option;

            if (!data) {

                $this.data('by.autocompleter', (data = new Autocompleter(this, options)))

            }

            if (typeof option == 'string') {

                data[option].apply(data, args)

            }

            return data;

        })

    }

    var old = $.fn.autocompleter;

    $.fn.autocompleter = Plugin;

    $.fn.autocompleter.Constructor = Autocompleter;

    $.fn.autocompleter.noConflict = function () {

        $.fn.autocompleter = old;

        return this

    }

}(jQuery);