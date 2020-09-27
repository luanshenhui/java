this.require.define({"eevee/image/config":function(exports, require, module){(function() {
  var Properties;

  Properties = require("eevee/config/properties");

  module.exports = function() {
    var alignProperty, hrefProperty, sizeProperty, urlProperty;
    this.unregisterConfigProperty("base", "component-align");
    this.baseInfo.name = "图片";
    this.baseInfo.description = "图片组件用于显示一张图片，并可以调整图片的大小为自适应或者原始尺寸。";
    this.configs.ext = {
      name: "图片设置"
    };
    alignProperty = new Properties.Property(this, {
      name: "image-align",
      label: "对齐",
      description: "图片如何对齐",
      type: "radio",
      options: {
        "left": "居左",
        "center": "居中",
        "right": "居右"
      },
      get: function() {
        if (/text-align:/.test(this.$target.attr("style"))) {
          return this.$target.css("text-align");
        } else {
          return "center";
        }
      },
      set: function(value) {
        return this.$target.css("text-align", value);
      }
    });
    sizeProperty = new Properties.Property(this, {
      name: "size",
      label: "大小",
      description: "自适应会匹配父容器的大小；原始尺寸则按图片原始大小显示，超出父容器的部分会被裁剪",
      type: "radio",
      useData: true,
      options: {
        "original": "原始尺寸",
        "justify": "自适应"
      },
      get: function() {
        return this._get() || "original";
      },
      set: function(value) {
        if (value === "justify") {
          this.$target.find("img").css("width", "100%");
        } else {
          this.$target.find("img").css("width", "");
        }
        return this._set(value);
      }
    });
    urlProperty = new Properties.ImageProperty(this, {
      name: "url",
      label: "图片",
      description: "选择或者上传一个图片，也可以直接填写图片地址",
      type: "button",
      useData: true,
      options: {
        "url": "<i class=\"fa fa-picture-o\"></i>&nbsp;选择或上传图片"
      },
      setCallback: function(url) {
        if (!url) {
          Essage.show({
            message: "图片组件不能将图片设置为空",
            status: "warning"
          }, 2000);
          return;
        }
        this.$target.find("img").attr("src", url);
        return sizeProperty.set(sizeProperty.get());
      }
    });
    hrefProperty = new Properties.Property(this, {
      name: "href",
      label: "链接",
      description: "为图片设置超链接",
      type: "text",
      useData: true,
      reRender: true,
      set: function(value) {
        if (!/^https?:\/\//.test(value)) {
          value = "http://" + value;
        }
        return this._set(value);
      }
    });
    return this.registerConfigProperty("ext", urlProperty, sizeProperty, alignProperty, hrefProperty);
  };

}).call(this);
;}});
this.require.define({"eevee/placeholder/config":function(exports, require, module){(function() {
  var Properties;

  Properties = require("eevee/config/properties");

  module.exports = function() {
    var heightProperty, hrefProperty;
    this.baseInfo.name = "占位块";
    this.baseInfo.description = "占位块不显示任何内容，只用于占位，可以手动调整高度并添加链接。";
    this.configs.ext = {
      name: "组件设置"
    };
    heightProperty = new Properties.Height(this, {
      description: "占位块的高度，单位像素，留空则不占空间",
      readOnly: false
    });
    hrefProperty = new Properties.Property(this, {
      name: "href",
      label: "链接",
      description: "为占位块设置超链接",
      type: "text",
      useData: true,
      reRender: true,
      set: function(value) {
        if (!/^https?:\/\//.test(value)) {
          value = "http://" + value;
        }
        return this._set(value);
      }
    });
    return this.registerConfigProperty("ext", heightProperty, hrefProperty);
  };

}).call(this);
;}});
this.require.define({"eevee/text/config":function(exports, require, module){(function() {
  var checker, commands, converter, innerDocument, makeCommand;

  converter = require("eevee/helpers/converter");

  checker = require("eevee/helpers/checker");

  innerDocument = void 0;

  makeCommand = function(command, param, callback) {
    return function(userParam) {
      var p;
      p = param != null ? param : userParam;
      if (_.isFunction(p)) {
        p = p();
      }
      return innerDocument.execCommand(command, false, p);
    };
  };

  commands = {
    bold: makeCommand("bold"),
    italic: makeCommand("italic"),
    strike: makeCommand("strikethrough"),
    underline: makeCommand("underline"),
    sub: makeCommand("subscript"),
    sup: makeCommand("superscript"),
    justifyfull: makeCommand("justifyfull"),
    justifycenter: makeCommand("justifycenter"),
    justifyleft: makeCommand("justifyleft"),
    justifyright: makeCommand("justifyright"),
    link: function() {
      var url;
      url = prompt("请输入链接地址");
      innerDocument.execCommand("createlink", false, url);
      return innerDocument.getSelection().anchorNode.parentElement.setAttribute("target", "_blank");
    },
    unlink: makeCommand("unlink"),
    size: function(userParam, $target) {
      var px;
      px = prompt("请输入像素大小，例如 12 ");
      if (!/px$/.test(px)) {
        px += "px";
      }
      px;
      innerDocument.execCommand("fontsize", false, 1);
      return $target.html($target.html().replace(/font\-size: x-small;/g, "font-size: " + px + ";"));
    },
    color: makeCommand("forecolor", function() {
      var color;
      color = prompt("请输入 6 位 16 进制颜色值，例如 FF0000 ");
      if (!checker.checkHexColor(color)) {
        return void 0;
      }
      return converter.prependPrefix(color, "#");
    }),
    formatblock: function() {
      var tag;
      tag = prompt("请输入标签的名称");
      return innerDocument.execCommand("formatblock", false, tag);
    },
    unformat: makeCommand("removeformat")
  };

  module.exports = function() {
    var $text, $that, onBlur;
    $that = this.comp.$comp;
    $text = this.comp.$comp.find(".text-content");
    $text.on({
      "keyup": function(evt) {
        return evt.stopPropagation();
      },
      "keydown": function(evt) {
        return evt.stopPropagation();
      }
    });
    innerDocument = innerDocument || this.comp.$comp.closest("html").parent()[0];
    this.baseInfo.name = "文字";
    this.baseInfo.description = "文字组件可以用于自定义文字内容。提供简单的排版，颜色和增加链接的功能。";
    onBlur = function() {
      $that.removeClass("eve-editing");
      $that.data("compData", {
        text: $text.html()
      });
      return $text.prop("contenteditable", false);
    };
    this.configs.ext = {
      name: "文本编辑",
      template: "<div class=\"field-group\" data-description=\"点击编辑解锁并编辑文字，点击完成锁定\">\n  <span class=\"field-group-content\">\n    <button name=\"edit\"><i class=\"fa fa-fw fa-pencil-square-o\"></i>&nbsp;编辑</button>\n    &nbsp;&nbsp;\n    <button name=\"done\"><i class=\"fa fa-fw fa-check\"></i>&nbsp;完成</button>\n  </span>\n</div>\n<div class=\"field-group\" data-description=\"文字大小 | 颜色 | 超链 | 取消超链\">\n  <span class=\"field-group-label\">文字:</span>\n  <span class=\"field-group-content\">\n    <span class=\"btn-group\">\n      <button class=\"small\" name=\"size\"><i class=\"fa fa-fw fa-text-height\"></i></button>\n      <button class=\"small\" name=\"color\"><i class=\"fa fa-fw fa-adjust\"></i></button>\n      <button class=\"small\" name=\"link\"><i class=\"fa fa-fw fa-chain\"></i></button>\n      <button class=\"small\" name=\"unlink\"><i class=\"fa fa-fw fa-chain-broken\"></i></button>\n    </span>\n  </span>\n</div>\n<div class=\"field-group\" data-description=\"粗体 | 斜体 | 删除线 | 下划线 | 标签 | 下标 | 上标\">\n  <span class=\"field-group-label\">样式:</span>\n  <span class=\"field-group-content\">\n    <span class=\"btn-group\">\n      <button class=\"small\" name=\"bold\"><i class=\"fa fa-fw fa-bold\"></i></button>\n      <button class=\"small\" name=\"italic\"><i class=\"fa fa-fw fa-italic\"></i></button>\n      <button class=\"small\" name=\"strike\"><i class=\"fa fa-fw fa-strikethrough\"></i></button>\n      <button class=\"small\" name=\"underline\"><i class=\"fa fa-fw fa-underline\"></i></button>\n    </span>\n    <span class=\"btn-group\">\n      <button class=\"small\" name=\"formatblock\"><i class=\"fa fa-fw fa-header\"></i></button>\n      <button class=\"small\" name=\"sub\"><i class=\"fa fa-fw fa-subscript\"></i></button>\n      <button class=\"small\" name=\"sup\"><i class=\"fa fa-fw fa-superscript\"></i></button>\n    </span>\n  </span>\n</div>\n<div class=\"field-group\" data-description=\"自适应 | 居中对齐 | 左对齐 | 右对齐\">\n  <span class=\"field-group-label\">排版:</span>\n  <span class=\"field-group-content\">\n    <span class=\"btn-group\">\n      <button class=\"small\" name=\"justifyfull\"><i class=\"fa fa-fw fa-align-justify\"></i></button>\n      <button class=\"small\" name=\"justifycenter\"><i class=\"fa fa-fw fa-align-center\"></i></button>\n      <button class=\"small\" name=\"justifyleft\"><i class=\"fa fa-fw fa-align-left\"></i></button>\n      <button class=\"small\" name=\"justifyright\"><i class=\"fa fa-fw fa-align-right\"></i></button>\n    </span>\n  </span>\n</div>\n<div class=\"field-group\" data-description=\"清除选中文字的所有状态，包括样式、链接和对齐等\">\n  <span class=\"field-group-label\">清除:</span>\n  <span class=\"field-group-content\">\n    <button name=\"unformat\"><i class=\"fa fa-fw fa-eraser\"></i>&nbsp;清除状态</button>\n  </span>\n</div>",
      init: function($form) {
        $form.find("button:not([name=edit])").prop("disabled", true);
        $form.find("button[name=edit]").click(function() {
          $(this).prop("disabled", true);
          $form.find("button:not([name=edit])").prop("disabled", false);
          $that.addClass("eve-editing");
          $text.prop("contenteditable", true);
          return $text.focus();
        });
        $form.find("button[name=done]").click(function() {
          $form.find("button[name=edit]").prop("disabled", false);
          $form.find("button:not([name=edit])").prop("disabled", true);
          return onBlur();
        });
        return _.each(commands, function(v, k) {
          return $form.find("button[name=" + k + "]").click(function() {
            $text.focus();
            v(void 0, $text);
            return false;
          });
        });
      }
    };
    this.destory = onBlur;
    return innerDocument.execCommand("styleWithCSS", false, true);
  };

}).call(this);
;}});
this.require.define({"eevee/video/config":function(exports, require, module){(function() {
  var Properties;

  Properties = require("eevee/config/properties");

  module.exports = function() {
    var domProperty, heightProperty, widthProperty;
    this.baseInfo.name = "视频";
    this.baseInfo.description = "可嵌入来自优酷、土豆等网站的视频。";
    this.configs.ext = {
      name: "组件设置"
    };
    widthProperty = new Properties.Width(this, {
      description: "视频宽度，单位像素，默认 100% 自适应",
      readOnly: false
    });
    heightProperty = new Properties.Height(this, {
      description: "视频高度，单位像素，默认 400 像素",
      readOnly: false
    });
    domProperty = new Properties.Property(this, {
      name: "dom",
      label: "代码",
      description: "视频嵌入代码，来源于视频网站的分享途径",
      type: "text",
      useData: true,
      set: function(value) {
        var $i, iHeight, iHtml, iWidth;
        if (value === "") {
          return this._set(void 0);
        } else {
          $i = $(value);
          iWidth = $i.width();
          if (iWidth === 0) {
            iWidth = parseInt($i.attr("width"));
          }
          iHeight = $i.height();
          if (iHeight === 0) {
            iHeight = parseInt($i.attr("height"));
          }
          if (iWidth && iWidth > 0) {
            widthProperty.dset(iWidth);
          }
          if (iHeight && iHeight > 0) {
            heightProperty.dset(iHeight);
          }
          $i.removeAttr("width").removeAttr("height").css("width", "").css("height", "");
          iHtml = $("<div></div>").append($i).html();
          this.$target.empty().append($i);
          return this._set(iHtml);
        }
      }
    });
    return this.registerConfigProperty("ext", widthProperty, heightProperty, domProperty);
  };

}).call(this);
;}});
this.require.define({"eevee":function(exports, require, module){(function() {
  require("eevee/extras/jquery.clean-whitespace");

  require("eevee/extras/ajax");

  require("eevee/extras/spinner");

  require("eevee/layout-editable");

}).call(this);
;}});
this.require.define({"eevee/c":function(exports, require, module){(function() {
  module.exports = {
    UNIT_W: 100
  };

}).call(this);
;}});
this.require.define({"eevee/children-appender":function(exports, require, module){(function() {
  var C, addThese, backElm, colElm, compCategories, compMaps, componentsCallback, containerElm, converter, cuColElm, editorArea, gridAutoElm, gridElm, imageSelector, layoutComps, rowElm, sideDialog, store, _compCategories;

  store = require("eevee/store").store;

  sideDialog = require("eevee/side-dialog");

  imageSelector = require("eevee/image-selector");

  layoutComps = require("eevee/layout-components");

  editorArea = require("eevee/editor-area");

  converter = require("eevee/helpers/converter");

  C = require("eevee/c");

  containerElm = {
    "class": "js-add-container",
    title: "容器-通栏",
    description: "宽度为 100% 的容器，可以容纳网格系统。"
  };

  gridElm = function(size) {
    return {
      "class": "js-add-grid",
      data: {
        size: size
      },
      title: "容器-网格" + size,
      description: "容纳行和列的容器，宽度为 " + size + " 的网格系统。"
    };
  };

  gridAutoElm = {
    "class": "js-add-grid",
    data: {
      size: "auto"
    },
    title: "容器-网格自适应",
    description: "容纳行和列的容器，会自适应外部容器的大小。"
  };

  rowElm = {
    "class": "js-add-row",
    title: "容器-行",
    description: "容纳列的容器。"
  };

  colElm = function(size) {
    return {
      "class": "js-add-col",
      data: {
        size: size
      },
      title: "容器-列" + size,
      description: "容纳组件的容器，宽度为 " + size + " 的列。"
    };
  };

  cuColElm = function(size) {
    return {
      "class": "js-add-cu-col",
      data: {
        size: size
      },
      title: "容器-列-自定义",
      description: "容纳组件的容器，宽度可随意设置的列。"
    };
  };

  backElm = {
    "class": "js-back",
    title: "返回",
    description: "返回上一级"
  };

  _compCategories = [];

  compCategories = function() {
    if (_compCategories.length === 0) {
      $(window).spin("Loading Components...");
      $.ajax({
        type: "GET",
        url: "/api/design/components/categories",
        data: {
          mode: store.mode
        },
        async: false,
        success: function(data) {
          data = converter.data(data);
          return _compCategories = _.map(data, function(value, key) {
            return {
              "class": "js-comp-category",
              data: {
                category: key
              },
              title: "组件分类-" + key,
              description: value
            };
          });
        },
        complete: function() {
          return $(window).spin(false);
        }
      });
    }
    return _compCategories;
  };

  compMaps = {};

  componentsCallback = {
    "default": function($dialog, comp, prepend, anchor) {
      var compData;
      compData = $(this).data("data");
      if (compData.maxCount && compData.maxCount > 0) {
        if (editorArea.inner().find(".eve-component[data-comp-path='" + compData.path + "']").length >= compData.maxCount) {
          Essage.show({
            message: "此组件在一个页面中最多只能存在 " + compData.maxCount + " 个",
            status: "warning"
          }, 2000);
          return;
        }
      }
      $dialog.spin();
      return new layoutComps.Component(compData.path, function() {
        comp.add(this, prepend, anchor);
        return sideDialog.close();
      }, function() {
        return $dialog.spin(false);
      });
    },
    "eevee/image": function($dialog, comp, prepend, anchor) {
      sideDialog.close();
      return imageSelector.show({
        multiple: true,
        uploadToSelect: true
      }).done(function(urls) {
        $(window).spin();
        return new layoutComps.Component("eevee/image", function() {
          _.each(urls, (function(_this) {
            return function(url) {
              var $newComp;
              $newComp = _this.$comp.clone();
              $newComp.find("img").attr("src", url);
              $newComp.data("compData", {
                url: url
              });
              return comp.add($newComp, prepend, anchor);
            };
          })(this));
          return $(window).spin(false);
        });
      });
    }
  };

  addThese = function(comp, types, prepend, anchor) {
    var compList;
    compList = _.map(types, function(type) {
      var space;
      switch (type) {
        case "container":
          return [containerElm];
        case "grid":
          return [gridElm(8), gridElm(10), gridElm(12), gridAutoElm];
        case "row":
          return [rowElm];
        case "col":
          if ((space = comp.emptySpace()) === 0) {
            Essage.show({
              message: "空间已满，不能添加更多列",
              status: "warning"
            }, 2000);
            return void 0;
          } else {
            return _.times(parseInt(space / C.UNIT_W), function(n) {
              return colElm(n + 1);
            }).concat([cuColElm(space)]);
          }
          break;
        case "comp":
          return compCategories();
      }
    });
    compList = _.compact(compList);
    if (compList.length === 0) {
      return;
    }
    return sideDialog.show({
      title: "添加组件",
      content: Handlebars.templates['eevee/components/children'](compList),
      callback: function($dialog) {
        $dialog.on("click", "li.js-add-container", function() {
          comp.add(new layoutComps.Container(), prepend, anchor);
          return sideDialog.close();
        });
        $dialog.on("click", "li.js-add-grid", function() {
          comp.add(new layoutComps.Grid($(this).data("data").size), prepend, anchor);
          return sideDialog.close();
        });
        $dialog.on("click", "li.js-add-row", function() {
          comp.add(new layoutComps.Row(), prepend, anchor);
          return sideDialog.close();
        });
        $dialog.on("click", "li.js-add-col", function() {
          comp.add(new layoutComps.Col($(this).data("data").size), prepend, anchor);
          return sideDialog.close();
        });
        $dialog.on("click", "li.js-add-cu-col", function() {
          comp.add(new layoutComps.CustomCol($(this).data("data").size), prepend, anchor);
          return sideDialog.close();
        });
        $dialog.on("click", "li.js-add-comp", function() {
          var cb;
          cb = componentsCallback[$(this).data("data").path] || componentsCallback["default"];
          return cb.call(this, $dialog, comp, prepend, anchor);
        });
        $dialog.on("click", "li.js-back", function() {
          return $dialog.find(".comp-add-list").replaceWith(Handlebars.templates['eevee/components/children'](compList));
        });
        return $dialog.on("click", "li.js-comp-category", function() {
          var category, f;
          category = $(this).data("data").category;
          f = function(comps) {
            return $dialog.find(".comp-add-list").replaceWith(Handlebars.templates['eevee/components/children']([[backElm], comps]));
          };
          if (compMaps[category]) {
            return f(compMaps[category]);
          } else {
            $dialog.spin();
            return $.ajax({
              type: "GET",
              url: "/api/design/components",
              data: {
                category: category
              },
              success: function(data) {
                data = converter.data(data);
                compMaps[category] = _.map(data, function(comp) {
                  return {
                    "class": "js-add-comp",
                    data: comp,
                    title: "组件-" + comp.name,
                    description: comp.description || comp.desc
                  };
                });
                return f(compMaps[category]);
              },
              complete: function() {
                return $dialog.spin(false);
              }
            });
          }
        });
      }
    });
  };

  module.exports = function(comp, prepend, anchor) {
    var types;
    types = (function() {
      switch (comp.type) {
        case "PagePart":
          return ["container", "grid"];
        case "Container":
          return ["grid"];
        case "Grid":
          return ["row", "comp"];
        case "Row":
          return ["col"];
        case "Col":
        case "CustomCol":
          return ["row", "comp"];
        case "Component":
          return void 0;
      }
    })();
    if (!types || types.length === 0) {
      return;
    }
    return addThese(comp, types, prepend, anchor);
  };

}).call(this);
;}});
this.require.define({"eevee/component-mask":function(exports, require, module){(function() {
  var $innerDocument, HoverMask, SelectedMask, editorArea, intervalId, layoutComps;

  editorArea = require("eevee/editor-area");

  layoutComps = require("eevee/layout-components");

  $innerDocument = void 0;

  HoverMask = (function() {
    var $target, get, oldConfig, template;
    $target = void 0;
    template = Handlebars.templates["eevee/hover-mask"];
    get = function() {
      if ($innerDocument !== void 0) {
        return $innerDocument.find(".eve-editor-hover-mask");
      } else {
        return $([]);
      }
    };
    oldConfig = void 0;
    return {
      ignoreHover: false,
      remove: function() {
        get().remove();
        return oldConfig = void 0;
      },
      setTarget: function($_target) {
        return $target = $_target;
      },
      show: function() {
        var $mask, $realTarget, bound, comp, config;
        if ($innerDocument === void 0) {
          return;
        }
        if (editorArea.isPreview()) {
          this.remove();
          return;
        }
        $realTarget = this.ignoreHover ? $target : $($innerDocument.find(":hover").slice(-1));
        if ($realTarget === void 0 || $realTarget.length === 0 || !$realTarget.is(layoutComps.selector)) {
          this.remove();
          return;
        }
        $mask = get();
        comp = layoutComps.getComp($realTarget);
        bound = comp.bound(true);
        config = {
          margin: {
            top: bound.top - bound.mt,
            left: bound.left - bound.ml,
            width: bound.width + bound.ml + bound.mr,
            height: bound.height + bound.mt + bound.mb
          },
          real: {
            top: bound.top,
            left: bound.left,
            width: bound.width,
            height: bound.height
          },
          name: $realTarget.hasClass("eve-part") ? "" + comp.name + " | 可编辑区域(" + (comp.$comp.data("partKey")) + ")" : comp.name
        };
        if (oldConfig !== void 0 && _.isEqual(config, oldConfig)) {
          return;
        }
        oldConfig = config;
        if ($mask.length > 0) {
          return get().replaceWith(template(config));
        } else {
          return $innerDocument.find("body").append(template(config));
        }
      }
    };
  })();

  SelectedMask = (function() {
    var get, oldConfig, template;
    template = Handlebars.templates["eevee/selected-mask"];
    oldConfig = void 0;
    get = function() {
      if ($innerDocument !== void 0) {
        return $innerDocument.find(".eve-editor-selected-mask");
      } else {
        return $([]);
      }
    };
    return {
      remove: function() {
        get().remove();
        return oldConfig = void 0;
      },
      show: function() {
        var $mask, $target, bound, comp, config;
        if ($innerDocument === void 0) {
          return;
        }
        if (editorArea.isPreview()) {
          this.remove();
          return;
        }
        $target = editorArea.selected();
        if ($target.length === 0 || $target.hasClass("eve-editing")) {
          this.remove();
          return;
        }
        $mask = get();
        comp = layoutComps.getComp($target);
        bound = comp.bound(true);
        config = {
          position: {
            top: bound.top,
            left: bound.left,
            width: bound.width,
            height: bound.height
          },
          name: $target.hasClass("eve-part") ? "" + comp.name + " | 可编辑区域(" + (comp.$comp.data("partKey")) + ")" : comp.name
        };
        if (oldConfig !== void 0 && _.isEqual(config, oldConfig)) {
          return;
        }
        oldConfig = config;
        if ($mask.length > 0) {
          get().replaceWith(template(config));
        } else {
          $innerDocument.find("body").append(template(config));
        }
        return this.rePositionTip();
      },
      rePositionTip: function() {
        var $mask, $target, bound, compTop;
        $mask = get();
        if ($mask.length === 0) {
          return;
        }
        $target = editorArea.selected();
        if ($target.length === 0) {
          this.remove();
          return;
        }
        bound = layoutComps.getComp($target).bound(true);
        compTop = bound.top - $innerDocument.scrollTop();
        if (compTop < (40 * (editorArea.isOverview() ? 2 : 1))) {
          $mask.addClass("eve-editor-selected-mask-tip-t").removeClass("eve-editor-selected-mask-tip-b");
          $mask.find("span").css("left", bound.left);
          return;
        }
        if (compTop > ($(window).height() * (editorArea.isOverview() ? 2 : 1))) {
          $mask.removeClass("eve-editor-selected-mask-tip-t").addClass("eve-editor-selected-mask-tip-b");
          $mask.find("span").css("left", bound.left);
          return;
        }
        $mask.removeClass("eve-editor-selected-mask-tip-t eve-editor-selected-mask-tip-b");
        return $mask.find("span").css("left", "");
      }
    };
  })();

  editorArea.onLoad(function($inner) {
    $innerDocument = $inner;
    return $innerDocument.scroll(function() {
      return SelectedMask.rePositionTip();
    });
  });

  intervalId = void 0;

  editorArea.get().mouseenter(function() {
    return HoverMask.ignoreHover = false;
  });

  editorArea.get().mouseleave(function() {
    return HoverMask.ignoreHover = true;
  });

  setInterval(function() {
    SelectedMask.show();
    return HoverMask.show();
  }, 100);

  module.exports = {
    ignoreRealHover: function(b) {
      return HoverMask.ignoreHover = b;
    },
    setHoverTarget: HoverMask.setTarget.bind(HoverMask)
  };

}).call(this);
;}});
this.require.define({"eevee/config/layout-components":function(exports, require, module){(function() {
  var Col, CommonJSHelper, Component, Config, Container, CustomCol, Grid, LayoutComp, PagePart, Properties, Row, cache, getConfig,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Properties = require("eevee/config/properties");

  LayoutComp = require("eevee/layout-components");

  CommonJSHelper = require("pokeball/helpers/commonjs");

  cache = {};

  Config = (function() {
    Config.prototype.type = "Config";

    function Config(comp) {
      var backgroundImage, backgroundPosition, backgroundRepeat, oldCallback;
      this.comp = comp;
      this.baseInfo = {
        name: "基础信息",
        props: [new Properties.Width(this), new Properties.Height(this)]
      };
      this.configs = {
        base: {
          name: "基础设置"
        },
        background: {
          name: "背景"
        }
      };
      this.registerConfigProperty("base", new Properties.Margin(this, "top"), new Properties.Margin(this, "bottom"));
      backgroundImage = new Properties.BackgroundImage(this);
      backgroundRepeat = new Properties.BackgroundRepeat(this);
      backgroundRepeat.init = function() {
        if (!backgroundImage.get()) {
          return this.hide();
        }
      };
      backgroundPosition = new Properties.BackgroundPosition(this);
      backgroundPosition.init = function() {
        if (!backgroundImage.get()) {
          return this.hide();
        }
      };
      oldCallback = backgroundImage.setCallback.bind(backgroundImage);
      backgroundImage.setCallback = function(url) {
        oldCallback(url);
        if (url) {
          backgroundRepeat.show();
          return backgroundPosition.show();
        } else {
          backgroundRepeat.dset("repeat");
          backgroundRepeat.hide();
          backgroundPosition.dset(false);
          return backgroundPosition.hide();
        }
      };
      this.registerConfigProperty("background", new Properties.BackgroundColor(this), backgroundImage, backgroundRepeat, backgroundPosition);
      cache[this.comp.uid()] = this;
    }

    Config.prototype.registerConfigProperty = function() {
      var properties, scope, _base, _base1;
      scope = arguments[0], properties = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if ((_base = this.configs)[scope] == null) {
        _base[scope] = {};
      }
      if ((_base1 = this.configs[scope]).props == null) {
        _base1.props = {};
      }
      return _.each(properties, (function(_this) {
        return function(property) {
          return _this.configs[scope].props[property.name] = property;
        };
      })(this));
    };

    Config.prototype.unregisterConfigProperty = function(scope, propertyName) {
      if (!this.configs[scope]) {
        return;
      }
      if (!this.configs[scope].props) {
        return;
      }
      return delete this.configs[scope].props[propertyName];
    };

    Config.prototype.init = function() {
      var callback, that;
      that = this;
      callback = function() {
        var value;
        if ($(this).is("input[type=checkbox]")) {
          value = $(this).prop("checked");
        } else {
          value = $(this).val();
        }
        return that.set($(this).closest("form").data("scope"), $(this).attr("name"), value);
      };
      this.$configPanel.on("change", "input, select, textarea", callback);
      this.$configPanel.on("click", "button", callback);
      this.$configPanel.on("submit", "form", function() {
        return false;
      });
      return this.$configPanel.find("form").each(function() {
        var scope;
        scope = $(this).data("scope");
        if (that.configs[scope].init) {
          that.configs[scope].init($(this));
        }
        return $(this).find(".field-group").each(function() {
          var name, prop;
          name = $(this).data("name");
          if (name) {
            prop = that.configs[scope].props[name];
            prop.$field = $(this);
            return typeof prop.init === "function" ? prop.init() : void 0;
          }
        });
      });
    };

    Config.prototype.set = function(scope, name, value) {
      if (this.configs[scope] && this.configs[scope].props && this.configs[scope].props[name]) {
        return this.configs[scope].props[name].set(value);
      }
    };

    Config.prototype.render = function() {
      this.$configPanel = $(Handlebars.templates["eevee/config-panel"](this._toJSON()));
      return this.$configPanel;
    };

    Config.prototype.reRender = function() {
      var oldUID, _ref;
      oldUID = (_ref = this.$comp) != null ? _ref.uid() : void 0;
      this.$configPanel.spin();
      return this.comp.reRender((function(_this) {
        return function() {
          delete cache[oldUID];
          return _this.comp.$comp.click();
        };
      })(this), (function(_this) {
        return function() {
          return _this.$configPanel.spin(false);
        };
      })(this));
    };

    Config.prototype._toJSON = function() {
      var _configs;
      _configs = {};
      _.each(this.configs, function(config, key) {
        _configs[key] = {
          name: config.name,
          description: config.description
        };
        if (config.props) {
          return _configs[key].props = _.map(config.props, function(prop) {
            return prop.toJSON();
          });
        } else {
          return _configs[key].template = _.isFunction(config.template) ? config.template() : config.template;
        }
      });
      return {
        baseInfo: {
          name: this.baseInfo.name,
          description: this.baseInfo.description,
          props: this.baseInfo.props.map(function(prop) {
            return prop.toJSON();
          })
        },
        configs: _configs
      };
    };

    return Config;

  })();

  PagePart = (function(_super) {
    __extends(PagePart, _super);

    PagePart.prototype.type = "PagePart";

    function PagePart() {
      PagePart.__super__.constructor.apply(this, arguments);
      this.baseInfo.name = "页面块";
      this.baseInfo.description = "页面块分为页头页尾和主体三部分，它们是内置的且不能被删除和新建。在页面块中可以添加通栏和网格。";
      this.configs.border = {
        name: "边框"
      };
      this.registerConfigProperty("border", new Properties.Border(this, "top"), new Properties.Border(this, "bottom"));
    }

    return PagePart;

  })(Config);

  Container = (function(_super) {
    __extends(Container, _super);

    Container.prototype.type = "Container";

    function Container() {
      Container.__super__.constructor.apply(this, arguments);
      this.baseInfo.name = "通栏";
      this.baseInfo.description = "通栏是没有固定高宽并且横穿整个页面的元素。在通栏中可以添加网格。";
      this.configs.border = {
        name: "边框"
      };
      this.registerConfigProperty("border", new Properties.Border(this, "top"), new Properties.Border(this, "bottom"));
    }

    return Container;

  })(Config);

  Grid = (function(_super) {
    __extends(Grid, _super);

    Grid.prototype.type = "Grid";

    function Grid() {
      Grid.__super__.constructor.apply(this, arguments);
      this.baseInfo.name = "网格";
      this.baseInfo.description = "网格是具有固定宽度和可变高度的容器，可用于容纳行级元素。网格总是在页面上居中显示。在网格中可以添加行和自定义组件。";
      this.configs.border = {
        name: "边框"
      };
      this.registerConfigProperty("border", new Properties.Border(this, "top"), new Properties.Border(this, "bottom"), new Properties.Border(this, "left"), new Properties.Border(this, "right"));
    }

    return Grid;

  })(Config);

  Row = (function(_super) {
    __extends(Row, _super);

    Row.prototype.type = "Row";

    function Row() {
      Row.__super__.constructor.apply(this, arguments);
      this.baseInfo.name = "行";
      this.baseInfo.description = "行用于组织多个列元素，行没有固定高宽并且总是会占满外部容器的整个宽度。在行中可以添加不多于它的外部容器大小的列。";
      this.registerConfigProperty("base", new Properties.RowAlign(this));
      this.configs.border = {
        name: "边框"
      };
      this.registerConfigProperty("border", new Properties.Border(this, "top"), new Properties.Border(this, "bottom"), new Properties.Border(this, "left"), new Properties.Border(this, "right"));
    }

    return Row;

  })(Config);

  Col = (function(_super) {
    __extends(Col, _super);

    Col.prototype.type = "Col";

    function Col() {
      Col.__super__.constructor.apply(this, arguments);
      this.baseInfo.name = "列";
      this.baseInfo.description = "列是具有固定宽度和可变高度的容器，可用于容纳行级元素。和网格不同，列可以横向排列多个，从而实现分栏布局。在列中可以添加行和自定义组件。";
      this.registerConfigProperty("base", new Properties.Margin(this, "left"), new Properties.Margin(this, "right"), new Properties.ColSize(this));
      this.configs.border = {
        name: "边框"
      };
      this.registerConfigProperty("border", new Properties.Border(this, "top"), new Properties.Border(this, "bottom"), new Properties.Border(this, "left"), new Properties.Border(this, "right"));
    }

    return Col;

  })(Config);

  CustomCol = (function(_super) {
    __extends(CustomCol, _super);

    CustomCol.prototype.type = "CustomCol";

    function CustomCol() {
      var customColSize;
      CustomCol.__super__.constructor.apply(this, arguments);
      this.baseInfo.name = "列-自定义";
      this.baseInfo.description = "自定义列在具有可变高度的同时可以自由的设置宽度，可用于容纳行级元素。和网格不同，列可以横向排列多个，从而实现分栏布局。在列中可以添加行和自定义组件。";
      customColSize = new Properties.CustomColSize(this);
      this.registerConfigProperty("base", new Properties.Margin(this, "left", customColSize), new Properties.Margin(this, "right", customColSize), customColSize);
      this.configs.border = {
        name: "边框"
      };
      this.registerConfigProperty("border", new Properties.Border(this, "top"), new Properties.Border(this, "bottom"), new Properties.Border(this, "left"), new Properties.Border(this, "right"));
    }

    return CustomCol;

  })(Config);

  Component = (function(_super) {
    __extends(Component, _super);

    Component.prototype.type = "Component";

    function Component() {
      var compPath, leftMargin, originSet, rightMargin;
      Component.__super__.constructor.apply(this, arguments);
      delete this.configs.background;
      leftMargin = new Properties.Margin(this, "left");
      rightMargin = new Properties.Margin(this, "right");
      this._componentAlign = new Properties.ComponentAlign(this);
      originSet = this._componentAlign.set;
      this._componentAlign.set = function(value) {
        switch (value) {
          case "eve-align-default":
            originSet.call(this, value);
            leftMargin.refresh().show();
            return rightMargin.refresh().show();
          case "eve-align-center":
            leftMargin.dset(0).hide();
            rightMargin.dset(0).hide();
            return originSet.call(this, value);
          case "eve-align-right":
            leftMargin.dset(0).hide();
            originSet.call(this, value);
            return rightMargin.refresh().show();
        }
      };
      this.registerConfigProperty("base", this._componentAlign, leftMargin, rightMargin);
      compPath = this.comp.$comp.data("compPath") + "/config";
      if (CommonJSHelper.hasModule(compPath)) {
        require(compPath).apply(this);
      }
      if (this.comp.$comp.data("compData") === void 0) {
        this.comp.$comp.data("compData", {});
      }
      if (this.comp.$comp.data("compGData") === void 0) {
        this.comp.$comp.data("compGData", {});
      }
    }

    Component.prototype.init = function() {
      Component.__super__.init.apply(this, arguments);
      return this._componentAlign.set(this._componentAlign.get());
    };

    return Component;

  })(Config);

  getConfig = function(comp) {
    var config;
    if (!comp.isComp) {
      comp = LayoutComp.getComp(comp);
    }
    if (config = cache[comp.uid()]) {
      return config;
    }
    switch (comp.type) {
      case "PagePart":
        return new PagePart(comp);
      case "Container":
        return new Container(comp);
      case "Grid":
        return new Grid(comp);
      case "Row":
        return new Row(comp);
      case "Col":
        return new Col(comp);
      case "CustomCol":
        return new CustomCol(comp);
      case "Component":
        return new Component(comp);
    }
  };

  module.exports = {
    getConfig: getConfig
  };

}).call(this);
;}});
this.require.define({"eevee/config/properties":function(exports, require, module){(function() {
  var BackgroundColor, BackgroundImage, BackgroundPosition, BackgroundRepeat, Border, C, ClassToggleProperty, ColSize, ComponentAlign, CustomColSize, Height, ImageProperty, Margin, Property, PxCssProperty, RowAlign, Width, checker, converter, fieldTemplate, getFrom, imageSelector, setTo, sideDialog,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  setTo = require("eevee/helpers/object-handler").setTo;

  getFrom = require("eevee/helpers/object-handler").getFrom;

  converter = require("eevee/helpers/converter");

  checker = require("eevee/helpers/checker");

  sideDialog = require("eevee/side-dialog");

  imageSelector = require("eevee/image-selector");

  C = require("eevee/c");

  fieldTemplate = Handlebars.templates["eevee/field-group"];

  Property = (function() {
    Property.prototype.name = void 0;

    Property.prototype.label = void 0;

    Property.prototype.type = void 0;

    Property.prototype["class"] = void 0;

    Property.prototype.description = void 0;

    Property.prototype.options = void 0;

    Property.prototype.readOnly = false;

    Property.prototype.template = void 0;

    Property.prototype.useData = false;

    Property.prototype.reRender = false;

    Property.prototype.init = void 0;

    Property.prototype["default"] = void 0;

    Property.prototype.hideValue = false;

    Property.prototype.memData = void 0;

    Property.prototype.global = false;

    function Property(config, settings) {
      this.config = config;
      this.comp = this.config.comp;
      this.$target = this.comp.$comp;
      this.useData = this.comp.type === "Component";
      if (settings) {
        if (settings.name !== void 0) {
          this.name = settings.name;
        }
        if (settings.global !== void 0) {
          this.global = settings.global;
        }
        if (settings.label !== void 0) {
          this.label = settings.label;
        }
        if (settings.type !== void 0) {
          this.type = settings.type;
        }
        if (settings["class"] !== void 0) {
          this["class"] = settings["class"];
        }
        if (settings.description !== void 0) {
          this.description = settings.description;
        }
        if (settings.options !== void 0) {
          this.options = settings.options;
        }
        if (settings.readOnly !== void 0) {
          this.readOnly = settings.readOnly;
        }
        if (settings.template !== void 0) {
          this.template = settings.template;
        }
        if (settings.get !== void 0) {
          this._get = this.get;
          this.get = settings.get;
        }
        if (settings.set !== void 0) {
          this._set = this.set;
          this.set = settings.set;
        }
        if (settings.init !== void 0) {
          this._init = this.init;
          this.init = settings.init;
        }
        if (settings.useData !== void 0) {
          this.useData = settings.useData;
        }
        if (settings.reRender !== void 0) {
          this.reRender = settings.reRender;
        }
        if (settings["default"] !== void 0) {
          this["default"] = settings["default"];
        }
        if (settings.hide !== void 0) {
          this.hideValue = settings.hide;
        }
      }
    }

    Property.prototype.dataKey = function() {
      if (this.global) {
        return "compGData";
      } else {
        return "compData";
      }
    };

    Property.prototype.get = function() {
      var data;
      if (this.useData) {
        data = getFrom(this.$target.data(this.dataKey()), this.name);
        if (data === void 0 && this["default"] !== void 0) {
          if (_.isFunction(this["default"])) {
            return this["default"]();
          } else {
            return this["default"];
          }
        } else {
          return data;
        }
      } else {
        return this.memData;
      }
    };

    Property.prototype.mset = function(value) {
      this.memData = value;
      return this;
    };

    Property.prototype.dset = function(value) {
      this.set(value);
      return this.refresh();
    };

    Property.prototype.set = function(value) {
      var oldValue;
      if (this.useData) {
        oldValue = getFrom(this.$target.data(this.dataKey()), this.name);
        if (value !== oldValue) {
          setTo(this.$target.data(this.dataKey()), this.name, value);
          if (this.reRender) {
            this.config.reRender();
          }
        }
      } else {
        this.memData = value;
      }
      return this;
    };

    Property.prototype.refresh = function() {
      var $field;
      if (this.$field) {
        $field = $(fieldTemplate(this.toJSON()));
        this.$field.replaceWith($field);
        this.$field = $field;
      }
      return this;
    };

    Property.prototype.show = function() {
      this.hideValue = false;
      if (!this.$field) {
        return;
      }
      this.$field.show();
      return this;
    };

    Property.prototype.hide = function() {
      this.hideValue = true;
      if (!this.$field) {
        return;
      }
      this.$field.hide();
      return this;
    };

    Property.prototype.toJSON = function() {
      return {
        name: this.name,
        label: this.label,
        global: this.global,
        type: this.type,
        "class": this["class"],
        description: this.description,
        value: this.get(),
        options: this.options,
        hide: this.hideValue,
        template: _.isFunction(this.template) ? this.template() : this.template
      };
    };

    return Property;

  })();

  PxCssProperty = (function(_super) {
    __extends(PxCssProperty, _super);

    function PxCssProperty() {
      return PxCssProperty.__super__.constructor.apply(this, arguments);
    }

    PxCssProperty.prototype.type = "text";

    PxCssProperty.prototype["class"] = "small";

    PxCssProperty.prototype.get = function() {
      return converter.px2Float(this.$target.css(this.name));
    };

    PxCssProperty.prototype.set = function(value) {
      value = parseFloat(value || 0);
      if (isNaN(value)) {
        return;
      }
      if (value > 0) {
        return this.$target.css(this.name, value + "px");
      } else {
        return this.$target.css(this.name, "");
      }
    };

    return PxCssProperty;

  })(Property);

  Width = (function(_super) {
    __extends(Width, _super);

    function Width() {
      return Width.__super__.constructor.apply(this, arguments);
    }

    Width.prototype.name = "width";

    Width.prototype.label = "宽度";

    Width.prototype.description = "组件宽度，单位像素";

    Width.prototype.readOnly = true;

    return Width;

  })(PxCssProperty);

  Height = (function(_super) {
    __extends(Height, _super);

    function Height() {
      return Height.__super__.constructor.apply(this, arguments);
    }

    Height.prototype.name = "height";

    Height.prototype.label = "高度";

    Height.prototype.description = "组件高度，单位像素";

    Height.prototype.readOnly = true;

    return Height;

  })(PxCssProperty);

  Margin = (function(_super) {
    __extends(Margin, _super);

    function Margin(config, direction, widthProp) {
      var descs;
      this.config = config;
      this.direction = direction;
      this.widthProp = widthProp;
      Margin.__super__.constructor.call(this, this.config);
      descs = {
        "top": "上",
        "bottom": "下",
        "left": "左",
        "right": "右"
      };
      this.name = "margin-" + this.direction;
      this.label = "" + descs[this.direction] + "边距";
      this.description = "元素与" + descs[this.direction] + "边元素之间的距离";
      if (!(this.direction === "left" || this.direction === "right")) {
        return;
      }
      if (this.comp.type === "Col") {
        this.prevValue = this.get();
      }
    }

    Margin.prototype.set = function(value) {
      var newWidth;
      Margin.__super__.set.apply(this, arguments);
      if (!(this.direction === "left" || this.direction === "right")) {
        return;
      }
      if (this.widthProp) {
        this.widthProp.refresh();
        return;
      }
      value = parseFloat(value || 0);
      if (isNaN(value)) {
        return;
      }
      if (this.comp.type === "Col") {
        newWidth = new Width(this.config).get() + this.prevValue - value;
        if (newWidth % C.UNIT_W === 0 && newWidth === this.comp.size()) {
          this.$target.css("width", "");
        } else {
          this.$target.css("width", newWidth + "px");
        }
        return this.prevValue = value;
      }
    };

    return Margin;

  })(PxCssProperty);

  Border = (function(_super) {
    __extends(Border, _super);

    Border.prototype.type = "button";

    Border.prototype.options = {
      "setting": "<i class=\"fa fa-gear\"></i>&nbsp;设置"
    };

    function Border(config, direction) {
      var borderConfig, descs;
      this.config = config;
      this.direction = direction;
      Border.__super__.constructor.call(this, this.config);
      descs = {
        "top": "上",
        "bottom": "下",
        "left": "左",
        "right": "右"
      };
      this.name = "border-" + this.direction;
      this.label = "" + descs[this.direction] + "边框";
      this.description = "设置元素" + descs[this.direction] + "边框的样式";
      if (!(this.direction === "left" || this.direction === "right")) {
        return;
      }
      borderConfig = this._getConfig();
      this.prevValue = borderConfig.style === "none" ? 0 : borderConfig.width;
    }

    Border.prototype._getConfig = function() {
      return {
        width: converter.px2Float(this.$target.css(this.name + "-width")),
        style: this.$target.css(this.name + "-style"),
        color: converter.rgb2Hex(this.$target.css(this.name + "-color"))
      };
    };

    Border.prototype.set = function() {
      var borderConfig, that;
      that = this;
      borderConfig = this._getConfig();
      return sideDialog.show({
        title: this.label,
        content: Handlebars.templates["eevee/properties/border-config"](borderConfig)
      }, function($dialog) {
        return $("#js-property-form").submit(function(evt) {
          var config, newValue, newWidth;
          evt.preventDefault();
          config = $(this).serializeObject();
          if (config.style === "none") {
            that.$target.css(that.name, "");
          } else {
            if (!checker.checkNumber(config.width, "边框宽度不是一个有效的数字，请重新填写")) {
              return;
            }
            if (!checker.checkHexColor(config.color, "边框颜色不是一个合法的颜色表达式，请重新填写")) {
              return;
            }
            that.$target.css(that.name, "" + (converter.appendSuffix(config.width, "px")) + " " + config.style + " " + (converter.prependPrefix(config.color, "#")));
            if (that.direction === "left" || that.direction === "right") {
              newValue = parseFloat(config.width);
              newWidth = new Width(that.config).get() + that.prevValue - newValue;
              if (newWidth % C.UNIT_W === 0 && newWidth === that.comp.size()) {
                that.$target.css("width", "");
              } else {
                that.$target.css("width", newWidth + "px");
              }
              that.prevValue = newValue;
            }
          }
          return sideDialog.close();
        });
      });
    };

    return Border;

  })(Property);

  BackgroundColor = (function(_super) {
    __extends(BackgroundColor, _super);

    function BackgroundColor() {
      return BackgroundColor.__super__.constructor.apply(this, arguments);
    }

    BackgroundColor.prototype.name = "background-color";

    BackgroundColor.prototype.label = "背景色";

    BackgroundColor.prototype.description = "元素背景色，请输入 6 位 16 进制颜色值例如 FF0000";

    BackgroundColor.prototype.type = "text";

    BackgroundColor.prototype.get = function() {
      return converter.rgb2Hex(this.$target.css(this.name));
    };

    BackgroundColor.prototype.set = function(value) {
      if (value) {
        if (!checker.checkHexColor(value, "背景色不是一个合法的颜色表达式，请重新设置")) {
          return;
        }
        return this.$target.css(this.name, converter.prependPrefix(value, "#"));
      } else {
        return this.$target.css(this.name, "");
      }
    };

    return BackgroundColor;

  })(Property);

  ImageProperty = (function(_super) {
    __extends(ImageProperty, _super);

    ImageProperty.prototype.type = "button";

    ImageProperty.prototype.options = {
      "url": "<i class=\"fa fa-picture-o\"></i>&nbsp;选择或上传图片"
    };

    function ImageProperty(config, settings) {
      this.config = config;
      ImageProperty.__super__.constructor.apply(this, arguments);
      if (settings) {
        this.setCallback = settings.setCallback;
      }
    }

    ImageProperty.prototype.set = function() {
      return imageSelector.show({
        originalUrl: this.get()
      }).done((function(_this) {
        return function(url) {
          var _ref;
          ImageProperty.__super__.set.apply(_this, arguments);
          return (_ref = _this.setCallback) != null ? _ref.call(_this, url) : void 0;
        };
      })(this));
    };

    return ImageProperty;

  })(Property);

  BackgroundImage = (function(_super) {
    __extends(BackgroundImage, _super);

    function BackgroundImage() {
      return BackgroundImage.__super__.constructor.apply(this, arguments);
    }

    BackgroundImage.prototype.name = "background-image";

    BackgroundImage.prototype.label = "背景图";

    BackgroundImage.prototype.description = "选择或者上传一个背景图片，也可以直接填写图片地址";

    BackgroundImage.prototype.get = function() {
      var url;
      url = this.$target.css(this.name);
      if (url === "none") {
        return void 0;
      } else {
        return /url\((.+)\)/.exec(url)[1];
      }
    };

    BackgroundImage.prototype.setCallback = function(url) {
      if (url) {
        return this.$target.css(this.name, "url(\"" + url + "\")");
      } else {
        return this.$target.css(this.name, "");
      }
    };

    return BackgroundImage;

  })(ImageProperty);

  BackgroundRepeat = (function(_super) {
    __extends(BackgroundRepeat, _super);

    function BackgroundRepeat() {
      return BackgroundRepeat.__super__.constructor.apply(this, arguments);
    }

    BackgroundRepeat.prototype.name = "background-repeat";

    BackgroundRepeat.prototype.label = "背景平铺";

    BackgroundRepeat.prototype.type = "radio";

    BackgroundRepeat.prototype.description = "选择背景图片的平铺方向";

    BackgroundRepeat.prototype.options = {
      "no-repeat": "无",
      "repeat-x": "横向",
      "repeat-y": "纵向",
      "repeat": "双向"
    };

    BackgroundRepeat.prototype.get = function() {
      return this.$target.css(this.name);
    };

    BackgroundRepeat.prototype.set = function(value) {
      if (value === "repeat") {
        return this.$target.css(this.name, "");
      } else {
        return this.$target.css(this.name, value);
      }
    };

    return BackgroundRepeat;

  })(Property);

  BackgroundPosition = (function(_super) {
    __extends(BackgroundPosition, _super);

    function BackgroundPosition() {
      return BackgroundPosition.__super__.constructor.apply(this, arguments);
    }

    BackgroundPosition.prototype.name = "background-position";

    BackgroundPosition.prototype.label = "背景居中";

    BackgroundPosition.prototype.type = "checkbox";

    BackgroundPosition.prototype.description = "背景图片是否在左右和上下方向上都居中";

    BackgroundPosition.prototype.get = function() {
      return /background\-position/.test(this.$target.attr("style"));
    };

    BackgroundPosition.prototype.set = function(value) {
      if (value) {
        return this.$target.css(this.name, "50% 50%");
      } else {
        return this.$target.css(this.name, "");
      }
    };

    return BackgroundPosition;

  })(Property);

  ColSize = (function(_super) {
    __extends(ColSize, _super);

    function ColSize() {
      return ColSize.__super__.constructor.apply(this, arguments);
    }

    ColSize.prototype.name = "col-size";

    ColSize.prototype.label = "列宽度";

    ColSize.prototype.description = "设置列的宽度，可取值为 1 - 12 的整数，分别占用 100px - 1200px 的空间；最大只能占满当前列的剩余空间，最小不能小于内部最大的固定宽度组件";

    ColSize.prototype.type = "text";

    ColSize.prototype["class"] = "small";

    ColSize.prototype.get = function() {
      return this.comp.size() / C.UNIT_W;
    };

    ColSize.prototype.set = function(value) {
      return this.comp.changeSize(parseInt(value));
    };

    return ColSize;

  })(Property);

  CustomColSize = (function(_super) {
    __extends(CustomColSize, _super);

    function CustomColSize() {
      return CustomColSize.__super__.constructor.apply(this, arguments);
    }

    CustomColSize.prototype.name = "cu-col-size";

    CustomColSize.prototype.label = "列宽度";

    CustomColSize.prototype.description = "设置列的宽度，最大只能占满当前列的剩余空间，最小不能小于内部最大的固定宽度组件";

    CustomColSize.prototype.type = "text";

    CustomColSize.prototype["class"] = "small";

    CustomColSize.prototype.get = function() {
      return this.comp.size();
    };

    CustomColSize.prototype.set = function(value) {
      return this.comp.changeSize(parseInt(value));
    };

    return CustomColSize;

  })(Property);

  ClassToggleProperty = (function(_super) {
    __extends(ClassToggleProperty, _super);

    ClassToggleProperty.prototype.type = "radio";

    function ClassToggleProperty() {
      ClassToggleProperty.__super__.constructor.apply(this, arguments);
      this.clazzList = Object.keys(this.options);
    }

    ClassToggleProperty.prototype.get = function() {
      var filted;
      filted = _.filter(this.clazzList, (function(_this) {
        return function(clazz) {
          return _this.$target.hasClass(clazz);
        };
      })(this));
      if (filted.length === 0) {
        return this.clazzList[0];
      } else {
        return filted[0];
      }
    };

    ClassToggleProperty.prototype.set = function(value) {
      this.$target.removeClass(this.clazzList.join(" "));
      if (value !== this.clazzList[0]) {
        return this.$target.addClass(value);
      }
    };

    return ClassToggleProperty;

  })(Property);

  ComponentAlign = (function(_super) {
    __extends(ComponentAlign, _super);

    function ComponentAlign() {
      return ComponentAlign.__super__.constructor.apply(this, arguments);
    }

    ComponentAlign.prototype.options = {
      "eve-align-default": "默认",
      "eve-align-center": "居中",
      "eve-align-right": "居右"
    };

    ComponentAlign.prototype.name = "component-align";

    ComponentAlign.prototype.label = "对齐";

    ComponentAlign.prototype.description = "组件在父元素中的对齐位置";

    return ComponentAlign;

  })(ClassToggleProperty);

  RowAlign = (function(_super) {
    __extends(RowAlign, _super);

    function RowAlign() {
      return RowAlign.__super__.constructor.apply(this, arguments);
    }

    RowAlign.prototype.options = {
      "eve-row-align-left": "左对齐",
      "eve-row-align-center": "居中对齐",
      "eve-row-align-right": "右对齐"
    };

    RowAlign.prototype.name = "row-content-align";

    RowAlign.prototype.label = "对齐";

    RowAlign.prototype.description = "行内列的对齐方向";

    return RowAlign;

  })(ClassToggleProperty);

  module.exports = {
    Property: Property,
    ImageProperty: ImageProperty,
    Width: Width,
    Height: Height,
    Margin: Margin,
    Border: Border,
    BackgroundColor: BackgroundColor,
    BackgroundImage: BackgroundImage,
    BackgroundRepeat: BackgroundRepeat,
    BackgroundPosition: BackgroundPosition,
    ColSize: ColSize,
    CustomColSize: CustomColSize,
    ComponentAlign: ComponentAlign,
    RowAlign: RowAlign
  };

}).call(this);
;}});
this.require.define({"eevee/editor-area":function(exports, require, module){(function() {
  var $inner, get, layoutComps, lazyload, onLoad, onSelect, onUnSelect, prepareSaveData, store, _isOverview, _isPreview, _onLoadList, _onSelect, _onUnSelect;

  layoutComps = require("eevee/layout-components");

  store = require("eevee/store").store;

  lazyload = require("eevee/helpers/lazyload");

  $inner = void 0;

  _onUnSelect = void 0;

  _onSelect = void 0;

  _onLoadList = [];

  _isPreview = false;

  _isOverview = false;

  onUnSelect = function() {
    $inner.find(".eve-selected").removeClass("eve-selected");
    return typeof _onUnSelect === "function" ? _onUnSelect($inner) : void 0;
  };

  onSelect = function($comp) {
    $comp.addClass("eve-selected");
    return typeof _onSelect === "function" ? _onSelect($inner, $comp) : void 0;
  };

  get = function() {
    return $(".editor-area");
  };

  onLoad = function() {
    var $itemEditArea;
    $inner = $(this).contents();
    $inner.find(".eve-image").css("height", "");
    lazyload.fake($inner);
    switch (store.mode) {
      case "ITEM":
        $itemEditArea = $inner.find(".eve-item");
        $itemEditArea.removeClass().addClass("eve-item eve-grid-auto eve-layout-comp eve-js-editable");
        $itemEditArea.find(layoutComps.allSelector).filter(function() {
          return $(this).parentsUntil(".eve-js-editable", ".eve-component").length === 0;
        }).addClass("eve-layout-comp");
        break;
      case "ITEM_TEMPLATE":
        $itemEditArea = $inner.find(".eve-item-t");
        $itemEditArea.removeClass().addClass("eve-item-t eve-grid-auto eve-layout-comp eve-js-editable");
        $itemEditArea.find(layoutComps.allSelector).addClass("eve-layout-comp");
        break;
      case "SHOP":
        $inner.find(".eve-part").addClass("eve-layout-comp eve-js-editable").find(layoutComps.allSelector).addClass("eve-layout-comp");
        break;
      case "TEMPLATE":
      case "OFFICIAL":
        $inner.find(layoutComps.PagePart.selector).addClass("eve-layout-comp eve-js-editable").each(function() {
          if ($(this).children().length === 0) {
            return layoutComps.getComp($(this)).add(new layoutComps.Grid(12));
          }
        });
        $inner.find(layoutComps.PagePart.selector).find(layoutComps.allSelector).addClass("eve-layout-comp");
    }
    if (!_isPreview) {
      $inner.find(".eve-js-editable").addClass("eve-editable");
    }
    if (_isOverview) {
      $inner.find("body").addClass("eve-overview");
    }
    $inner.on("click", layoutComps.selector, function() {
      if ($(this).closest(".eve-editable").length === 0) {
        return;
      }
      if ($(this).hasClass("eve-selected")) {
        return false;
      }
      onUnSelect();
      onSelect($(this));
      return false;
    });
    $inner.click(function() {
      onUnSelect();
      return false;
    });
    _onLoadList.forEach(function(callback) {
      return callback($inner);
    });
    return $(window).spin(false);
  };

  prepareSaveData = function($target) {
    var $components, $parts, $saveTarget, componentDatas, componentTemplates, editableClasses, gdatas, htmlString, partTemplates;
    $target.find(".eve-image").each(function() {
      return $(this).css("height", $(this).innerHeight());
    });
    $saveTarget = $target.clone(true, true);
    $parts = $saveTarget.find(".eve-part");
    partTemplates = {};
    gdatas = {};
    _.each($parts, function(comp) {
      return partTemplates[$(comp).data("partKey")] = prepareSaveData($(comp)).html;
    });
    $parts.each(function() {
      return $(this).replaceWith("{{render \"part\" \"" + ($(this).data("partKey")) + "\"}}");
    });
    $components = $saveTarget.find(".eve-component.eve-layout-comp");
    editableClasses = ["eve-editable", "eve-js-editable", "eve-layout-comp", "eve-selected", "eve-editing", "eve-animation"];
    $saveTarget.removeClass(editableClasses.join(" "));
    $saveTarget.find(editableClasses.map(function(clazz) {
      return "." + clazz;
    }).join(",")).removeClass(editableClasses.join(" "));
    $saveTarget.find("*").removeAttr("contenteditable");
    componentTemplates = _.map($components, function(comp) {
      return layoutComps.getComp($(comp).cleanUid()).getTemplate();
    });
    componentDatas = _.map($components, function(comp) {
      return layoutComps.getComp($(comp).cleanUid()).getSavedData();
    });
    $components.replaceWith("<component-placeholder></component-placeholder>");
    $saveTarget.cleanWhitespace(true);
    $saveTarget = $("<div></div>").append($saveTarget);
    htmlString = $saveTarget.html();
    $saveTarget.remove();
    _.each(componentDatas, function(compData) {
      htmlString = htmlString.replace(/<component-placeholder><\/component-placeholder>/, compData.template);
      if (compData.gdata) {
        gdatas[compData.path] = JSON.stringify(compData.gdata);
      }
      return true;
    });
    $target.find(".eve-image").css("height", "");
    return {
      html: htmlString,
      parts: partTemplates,
      gdatas: gdatas
    };
  };

  get().load(onLoad);

  module.exports = {
    get: get,
    inner: function() {
      return $inner;
    },
    innerWindow: function() {
      return get()[0].contentWindow;
    },
    unSelect: onUnSelect,
    onLoad: function(onLoad) {
      return _onLoadList.push(onLoad);
    },
    onSelect: function(onSelect) {
      return _onSelect = onSelect;
    },
    onUnSelect: function(onUnSelect) {
      return _onUnSelect = onUnSelect;
    },
    selected: function() {
      return this.inner().find(".eve-selected");
    },
    goToSelected: function() {
      if (this.selected().length > 0) {
        return this.inner().scrollTop(this.selected().offset().top - 50);
      }
    },
    setUrl: function(url) {
      $(window).spin("Page Rendering...");
      if (url.indexOf("?") > 0) {
        return this.get().attr("src", url + ("&t=" + (Math.random())));
      } else {
        return this.get().attr("src", url + ("?t=" + (Math.random())));
      }
    },
    clean: function() {
      return this.inner().find("body").empty();
    },
    isPreview: function() {
      return _isPreview;
    },
    togglePreview: function() {
      _isPreview = !_isPreview;
      if (_isPreview) {
        this.inner().find(".eve-editor-area-inner").addClass("eve-hide");
        this.inner().find(".eve-animation").removeClass("eve-animation");
        return this.inner().find(".eve-js-editable").removeClass("eve-editable");
      } else {
        if (this.selected.length > 0) {
          this.inner().find(".eve-editor-area-inner").removeClass("eve-hide");
        }
        return this.inner().find(".eve-js-editable").addClass("eve-editable");
      }
    },
    isOverview: function() {
      return _isOverview;
    },
    toggleOverview: function() {
      _isOverview = !_isOverview;
      get().toggleClass("overview");
      return this.inner().find("body").toggleClass("eve-overview");
    },
    save: function() {
      var body, data, footer, gdatas, header, parts, url;
      $(window).spin("Saving...");
      switch (store.mode) {
        case "TEMPLATE":
        case "OFFICIAL":
          header = prepareSaveData(this.inner().find(".eve-header"));
          body = prepareSaveData(this.inner().find(".eve-body"));
          footer = prepareSaveData(this.inner().find(".eve-footer"));
          gdatas = _.extend(header.gdatas, body.gdatas, footer.gdatas);
          url = "/api/design/instances/template/" + store.instance.id;
          data = {
            pageId: store.currentPage.id,
            header: header.html,
            body: body.html,
            footer: footer.html
          };
          if (_.size(body.parts) > 0) {
            data.parts = JSON.stringify(body.parts);
          }
          if (_.size(gdatas) > 0) {
            data.gdatas = JSON.stringify(gdatas);
          }
          break;
        case "SHOP":
          parts = {};
          _.each(this.inner().find(".eve-part"), function(comp) {
            return parts[$(comp).data("partKey")] = prepareSaveData($(comp)).html;
          });
          url = "/api/design/instances/site/" + store.instance.id;
          data = {
            pageId: store.currentPage.id,
            parts: JSON.stringify(parts)
          };
          break;
        case "ITEM":
          url = "/api/design/items/" + store.itemId;
          data = {
            template: prepareSaveData(this.inner().find(".eve-item")).html
          };
          break;
        case "ITEM_TEMPLATE":
          url = "/api/design/item-templates/" + store.spuId;
          data = {
            template: prepareSaveData(this.inner().find(".eve-item-t")).html
          };
      }
      return $.ajax({
        type: "POST",
        url: "" + url + "?_method=PUT",
        data: data,
        success: function() {
          return Essage.show({
            message: "保存成功",
            status: "success"
          }, 3000);
        },
        complete: function() {
          return $(window).spin(false);
        }
      });
    }
  };

}).call(this);
;}});
this.require.define({"eevee/extras/ajax":function(exports, require, module){(function() {
  var store;

  store = require("eevee/store");

  $.ajaxPrefilter(function(options, originalOptions, jqXHR) {
    return jqXHR.originalOptions = originalOptions;
  });

  $.ajaxSetup({
    data: {
      group: store.group,
      app: store.app
    }
  });

  $(document).ajaxError(function(evt, jqXHR) {
    if (jqXHR.status === 401) {
      return require("eevee/extras/login")(jqXHR);
    } else {
      if (jqXHR.responseText) {
        return Essage.show({
          message: jqXHR.responseText.split("\n")[0],
          status: "error"
        }, 3000);
      }
    }
  });

}).call(this);
;}});
this.require.define({"eevee/extras/jquery.clean-whitespace":function(exports, require, module){(function() {
  jQuery.fn.cleanWhitespace = function(deep) {
    this.contents().filter(function() {
      if (this.nodeType !== 3) {
        if (deep) {
          $(this).cleanWhitespace(deep);
        }
        return false;
      } else {
        this.textContent = $.trim(this.textContent);
        return !/\S/.test(this.nodeValue);
      }
    }).remove();
    return this;
  };

}).call(this);
;}});
this.require.define({"eevee/extras/jquery.unique-id":function(exports, require, module){(function() {
  var uuid;

  uuid = 0;

  $.fn.extend({
    uid: function() {
      var result;
      result = this.map(function() {
        if (!$(this).data("uid")) {
          $(this).data("uid", (++uuid).toString());
        }
        return $(this).data("uid");
      });
      if (result.length === 1) {
        return result[0];
      } else {
        return result;
      }
    },
    cleanUid: function() {
      this.each(function() {
        return $(this).removeData("uid");
      });
      return this;
    }
  });

}).call(this);
;}});
this.require.define({"eevee/extras/login":function(exports, require, module){(function() {
  var sideDialog, template;

  sideDialog = require("eevee/side-dialog");

  template = Handlebars.templates["eevee/extras/login"];

  module.exports = function(jqXHR) {
    return sideDialog.show({
      title: "重登录",
      content: template()
    }, function($dialog) {
      return $("#js-login-form").submit(function() {
        $.ajax({
          type: "POST",
          url: "/api/user/login",
          data: $(this).serialize(),
          success: function() {
            Essage.show({
              message: "登录成功",
              status: "success"
            }, 2000);
            sideDialog.close();
            if (jqXHR) {
              return $.ajax(jqXHR.originalOptions);
            }
          }
        });
        return false;
      });
    });
  };

}).call(this);
;}});
this.require.define({"eevee/extras/spinner":function(exports, require, module){(function() {
  var template;

  template = Handlebars.templates["eevee/extras/spinner"];

  $.fn.extend({
    spin: function(enable) {
      var $target, isWindow, message;
      isWindow = this[0] === window;
      $target = isWindow ? $("body") : $(this);
      $target.children(".eevee-spinner").remove();
      if (enable === false) {
        if ($target.data("eevee-spinner")) {
          $target.css("position", "");
        }
      } else {
        if ($target.css("position") === "static" && !isWindow) {
          $target.data("eevee-spinner", true);
          $target.css("position", "relative");
        }
        message = enable ? "[ " + enable + " ]" : void 0;
        $target.append(template({
          isWindow: isWindow,
          message: message
        }));
      }
      return $(this);
    }
  });

}).call(this);
;}});
this.require.define({"eevee/helpers/checker":function(exports, require, module){(function() {
  module.exports = {
    checkNumber: function(number, message) {
      var result;
      result = /^[\d\.]+$/.test(number);
      if (!result) {
        Essage.show({
          message: message || "非法的数字",
          status: "error"
        }, 3000);
      }
      return result;
    },
    checkHexColor: function(color, message) {
      var result;
      result = (function(color) {
        if (!color) {
          return false;
        }
        if (color[0] === "#") {
          color = color.slice(1);
        }
        if (!(color.length === 3 || color.length === 6)) {
          return false;
        }
        return /^[0-9a-fA-F]+$/.test(color);
      })(color);
      if (!result) {
        Essage.show({
          message: message || "非法的颜色表达式",
          status: "error"
        }, 3000);
      }
      return result;
    }
  };

}).call(this);
;}});
this.require.define({"eevee/helpers/converter":function(exports, require, module){(function() {
  module.exports = {
    rgb2Hex: function(original) {
      var colors;
      colors = /rgba?\((\d+),\s*(\d+),\s*(\d+)(,\s*(\d+))?\)/.exec(original);
      if (colors[5] && parseInt(colors[5]) === 0) {
        return void 0;
      }
      return "#" + [colors[1], colors[2], colors[3]].map(function(color) {
        var colorStr;
        colorStr = parseInt(color).toString(16);
        if (colorStr.length === 1) {
          return "0" + colorStr;
        } else {
          return colorStr;
        }
      }).join("");
    },
    px2Float: function(original) {
      return parseFloat(/([\d\.]+)px/.exec(original)[1]);
    },
    appendSuffix: function(original, suffix) {
      var lastIndex;
      original = original.toString();
      lastIndex = original.lastIndexOf(suffix);
      if (lastIndex !== -1 && (lastIndex + suffix.length) === original.length) {
        return original;
      } else {
        return original + "px";
      }
    },
    prependPrefix: function(original, prefix) {
      original = original.toString();
      if (original.indexOf(prefix) === 0) {
        return original;
      } else {
        return prefix + original;
      }
    },
    data: function(data) {
      if (data && data.data && data.status && _.size(data) === 2) {
        return data.data;
      } else {
        return data;
      }
    }
  };

}).call(this);
;}});
this.require.define({"eevee/helpers/lazyload":function(exports, require, module){(function() {
  module.exports = {
    fake: function($dom) {
      return $dom.find("img[data-original]").each(function() {
        return $(this).attr("src", $(this).data("original"));
      });
    }
  };

}).call(this);
;}});
this.require.define({"eevee/helpers/object-handler":function(exports, require, module){(function() {
  var getFrom, setTo, _getFrom, _setTo;

  setTo = function(obj, name, value) {
    var names;
    name = name.replace(/\[(\d+)]/g, ".$1");
    names = name.split(".");
    _setTo(obj, names, value);
    return obj;
  };

  _setTo = function(obj, names, value) {
    var name, oldValue;
    name = names[0];
    if (names.length === 1) {
      oldValue = obj[name];
      obj[name] = value;
      return oldValue;
    }
    if (obj[name] === void 0) {
      if (isNaN(parseInt(names[1]))) {
        obj[name] = {};
      } else {
        obj[name] = [];
      }
    }
    return _setTo(obj[name], names.slice(1), value);
  };

  getFrom = function(obj, name) {
    var names;
    name = name.replace(/\[(\d+)]/g, ".$1");
    names = name.split(".");
    return _getFrom(obj, names);
  };

  _getFrom = function(obj, names) {
    var name;
    if (obj === void 0 || names.length === 0) {
      return obj;
    }
    name = names[0];
    return _getFrom(obj[name], names.slice(1));
  };

  module.exports = {
    setTo: setTo,
    getFrom: getFrom
  };

}).call(this);
;}});
this.require.define({"eevee/image-selector":function(exports, require, module){(function() {
  var close, converter, listTemplate, show, sideDialog, store, template, _get, _getList, _loadImages;

  sideDialog = require("eevee/side-dialog");

  converter = require("eevee/helpers/converter");

  store = require("eevee/store").store;

  template = Handlebars.templates["eevee/image-selector/root"];

  listTemplate = Handlebars.templates["eevee/image-selector/list"];

  _get = function() {
    return $(".image-selector");
  };

  _getList = function() {
    return $(".image-selector-list");
  };

  _loadImages = function(page, reRender) {
    _get().find(".js-ok, .js-delete").prop("disabled", true);
    _getList().spin();
    if (page === void 0) {
      $(".image-selector-pagination").trigger("currentPage");
      return;
    }
    return $.ajax({
      type: "GET",
      url: "/api/images/user",
      data: {
        p: page,
        size: 12,
        category: _get().data("category")
      },
      success: function(data) {
        var images;
        data = converter.data(data);
        images = _.groupBy(data.data, function(image, index) {
          return Math.floor(index / 4);
        });
        _getList().html(listTemplate(images));
        if (reRender) {
          return $(".image-selector-pagination").pagination(data.total, {
            items_per_page: 12,
            num_edge_entries: 1,
            num_display_entries: 6,
            link_to: "javascript:void(0);",
            prev_text: "上一页",
            next_text: "下一页",
            load_first_page: false,
            callback: function(page) {
              return _loadImages(page + 1, false);
            }
          });
        }
      }
    });
  };

  close = function() {
    return _get().remove();
  };

  show = function(config) {
    var category, defaultConfig, deferred, doneCount, img, original, setUrl, successImages, uploadingCount;
    if (_get().length > 0) {
      return;
    }
    defaultConfig = {
      multiple: false,
      uploadToSelect: false,
      originalUrl: void 0
    };
    config = _.extend(defaultConfig, config || {});
    if (config.originalUrl) {
      img = new Image();
      img.src = config.originalUrl;
      original = {
        url: config.originalUrl,
        width: img.naturalWidth,
        height: img.naturalHeight
      };
    }
    category = store.mode === "ITEM" ? "item:" + store.itemId : store.mode === "ITEM_TEMPLATE" ? "spu:" + store.spuId : void 0;
    deferred = $.Deferred();
    $(".editor").append(template({
      multiple: config.multiple,
      original: original,
      category: category
    }));
    _loadImages(1, true);
    _get().find(".image-selector-tab > li").click(function() {
      if ($(this).hasClass("active")) {
        return;
      }
      $(this).addClass("active").siblings().removeClass("active");
      if ($(this).data("category")) {
        _get().data("category", $(this).data("category"));
      } else {
        _get().data("category", "");
      }
      return _loadImages(1, true);
    });
    _getList().on({
      "click": function() {
        if (config.multiple) {
          $(this).toggleClass("selected");
        } else {
          _getList().find(".selected").removeClass("selected");
          $(this).addClass("selected");
        }
        _get().find(".image-selector-url").val("");
        return _get().find(".js-ok, .js-delete").prop("disabled", _getList().find(".selected").length === 0);
      }
    }, "span");
    uploadingCount = 0;
    doneCount = 0;
    successImages = [];
    _get().find("#js-image-upload").fileupload({
      url: "/api/images/upload",
      dataType: "html",
      formData: function() {
        if (category = _get().data("category")) {
          return [
            {
              name: "category",
              value: _get().data("category")
            }
          ];
        } else {
          return [];
        }
      },
      send: function() {
        if (++uploadingCount === 1) {
          return _get().find(".image-selector-upload").addClass("disabled").spin();
        }
      },
      done: function(evt, data) {
        return successImages.push(JSON.parse(data.result)[0]);
      },
      always: function() {
        var orderedImages;
        if (++doneCount === uploadingCount) {
          if (config.uploadToSelect) {
            orderedImages = _.sortBy(successImages, function(image) {
              return image.name.substring(0, image.name.lastIndexOf("."));
            });
            deferred.resolve(_.map(orderedImages, function(image) {
              return image.url;
            }));
            close();
          } else {
            _loadImages(1, true);
            _get().find(".image-selector-upload").removeClass("disabled").spin(false);
          }
          if (uploadingCount > 1) {
            Essage.show({
              message: "共上传 " + uploadingCount + " 个图片，成功 " + successImages.length + " 个",
              status: uploadingCount === successImages.length ? "success" : "warning"
            }, 2000);
          }
          uploadingCount = 0;
          successImages = [];
          return doneCount = 0;
        }
      }
    });
    setUrl = function() {
      if ($(this).val()) {
        _getList().find(".selected").removeClass("selected");
        _get().find(".js-delete").prop("disabled", true);
        return _get().find(".js-ok").prop("disabled", false);
      } else if (_get().find(".selected").length === 0) {
        return _get().find(".js-ok").prop("disabled", true);
      }
    };
    _get().find(".image-selector-url").keyup(setUrl);
    _get().find(".image-selector-url").change(setUrl);
    _get().find(".js-delete").click(function() {
      var selectedList;
      selectedList = _getList().find(".selected");
      if (selectedList.length === 0) {
        return;
      }
      return sideDialog.confirm("删除图片", "确认删除图片吗？删除后将不能恢复，并且之前使用了此图片的地方都将无法显示！").done((function(_this) {
        return function() {
          var imageIds;
          $(_this).prop("disabled", true).spin();
          _getList().spin();
          if (selectedList.length === 1) {
            return $.ajax({
              type: "POST",
              url: "/api/images/" + (selectedList.data("id")) + "?_method=DELETE",
              success: function() {
                return _loadImages(void 0, true);
              },
              complete: function() {
                return $(_this).spin(false);
              }
            });
          } else {
            imageIds = _.map(selectedList, function(s) {
              return $(s).data("id");
            });
            return $.ajax({
              type: "POST",
              url: "/api/images/batch_delete",
              data: {
                imageIds: imageIds
              },
              success: function(data) {
                data = converter.data(data);
                Essage.show({
                  message: "删除 " + imageIds.length + " 张图片，成功 " + data + " 张",
                  status: imageIds.length === parseInt(data) ? "success" : "warning"
                }, 2000);
                return _loadImages(void 0, true);
              },
              complete: function() {
                return $(_this).spin(false);
              }
            });
          }
        };
      })(this));
    });
    _get().find(".js-cancel").click(function() {
      deferred.reject();
      return close();
    });
    _get().find(".js-clean").click(function() {
      deferred.resolve(null);
      return close();
    });
    _get().find(".js-ok").click(function() {
      var url;
      url = _get().find(".image-selector-url").val();
      if (url) {
        if (config.multiple) {
          url = [url];
        }
      } else {
        url = config.multiple ? _.map(_getList().find(".selected"), function(i) {
          return $(i).data("url");
        }) : _getList().find(".selected").data("url");
      }
      deferred.resolve(url);
      return close();
    });
    return deferred.promise();
  };

  module.exports = {
    show: show,
    isShowing: function() {
      return _get().length > 0;
    },
    close: close,
    deleteSelected: function() {
      return _get().find(".js-delete").click();
    }
  };

}).call(this);
;}});
this.require.define({"eevee/inner-script":function(exports, require, module){(function() {
  module.exports = {
    require: function(path) {
      return $(".editor-area")[0].contentWindow.require(path);
    }
  };

}).call(this);
;}});
this.require.define({"eevee/key-shortcut-tip":function(exports, require, module){(function() {
  var get, remove, show, tipTemplate;

  tipTemplate = Handlebars.templates["eevee/key-shortcut-tip"];

  get = function() {
    return $(".key-shortcut-tip");
  };

  remove = function() {
    return get().remove();
  };

  show = function() {
    if (get().length > 0) {
      return;
    }
    $(".editor").append(tipTemplate());
    return $(".key-shortcut-close").click(function() {
      remove();
      return false;
    });
  };

  module.exports = {
    show: show,
    close: remove,
    isShowing: function() {
      return get().length > 0;
    }
  };

}).call(this);
;}});
this.require.define({"eevee/key-shortcut":function(exports, require, module){(function() {
  var childrenAppender, copyedComp, editorArea, handlerMap, imageSelector, keyMap, keyShortcutTip, layoutComps, preventSomething, register, shortcutHandler, sideDialog, workbench;

  layoutComps = require("eevee/layout-components");

  editorArea = require("eevee/editor-area");

  sideDialog = require("eevee/side-dialog");

  imageSelector = require("eevee/image-selector");

  childrenAppender = require("eevee/children-appender");

  workbench = require("eevee/workbench");

  keyShortcutTip = require("eevee/key-shortcut-tip");

  keyMap = {
    "ESC": 27,
    "DELETE": 8,
    "ENTER": 13,
    "/": 191
  };

  handlerMap = {};

  copyedComp = {
    time: void 0,
    id: void 0,
    html: void 0,
    comp: void 0
  };

  register = function(shortcut, handler) {
    return shortcut.split(",").forEach(function(k) {
      var key, parts, realKey, targetShortcut;
      parts = k.trim().split("+").map(function(part) {
        return part.toUpperCase();
      });
      key = parts.slice(-1)[0];
      realKey = keyMap[key] || key.charCodeAt(0);
      targetShortcut = parts.slice(0, -1).sort().concat(realKey).join("+");
      return handlerMap[targetShortcut] = handler;
    });
  };

  preventSomething = function(evt) {
    if ($(evt.target).is("input[type=text], textarea")) {
      return true;
    }
    switch (evt.keyCode) {
      case 8:
        return evt.preventDefault();
      default:
        return true;
    }
  };

  shortcutHandler = function(evt, $inner) {
    var handler, shortcut;
    if ($(evt.target).is("input[type=text], textarea")) {
      return false;
    }
    shortcut = [];
    if (evt.altKey) {
      shortcut.push("ALT");
    }
    if (evt.ctrlKey) {
      shortcut.push("CTRL");
    }
    if (evt.shiftKey) {
      shortcut.push("SHIFT");
    }
    shortcut.push(evt.keyCode);
    handler = handlerMap[shortcut.join("+")];
    if (!handler) {
      return false;
    }
    handler({
      alt: evt.altKey,
      ctrl: evt.ctrlKey,
      shift: evt.shiftKey
    });
    return true;
  };

  register("ESC", function() {
    if (sideDialog.isShowing()) {
      sideDialog.cancel();
      return;
    }
    if (imageSelector.isShowing()) {
      imageSelector.close();
      return;
    }
    if (keyShortcutTip.isShowing()) {
      keyShortcutTip.close();
      return;
    }
    if (editorArea.inner()) {
      return editorArea.unSelect();
    }
  });

  register("DELETE", function() {
    var selected;
    if (imageSelector.isShowing()) {
      imageSelector.deleteSelected();
      return;
    }
    if (!sideDialog.isShowing() && !editorArea.isPreview()) {
      selected = editorArea.selected();
      if (selected.length > 0) {
        return layoutComps.getComp(selected).remove(function() {
          return editorArea.unSelect();
        });
      }
    }
  });

  register("ENTER", function() {
    if (sideDialog.isShowing()) {
      return sideDialog.ok();
    }
  });

  register("a, shift+a", function(e) {
    var selected;
    if (!sideDialog.isShowing() && !editorArea.isPreview()) {
      selected = editorArea.selected();
      if (selected.length > 0) {
        return childrenAppender(layoutComps.getComp(selected), e.shift);
      }
    }
  });

  register("i, shift+i", function(e) {
    var selected, selectedComp;
    if (!sideDialog.isShowing() && !editorArea.isPreview()) {
      selected = editorArea.selected();
      if (selected.length === 0) {
        return;
      }
      selectedComp = layoutComps.getComp(selected);
      if (selectedComp.parent() === void 0) {
        return;
      }
      return childrenAppender(selectedComp.parent(), e.shift, selectedComp);
    }
  });

  register("p", function() {
    return workbench.editMenu.togglePreview();
  });

  register("l", function() {
    return workbench.editMenu.togglePageList();
  });

  register("o", function() {
    return workbench.editMenu.toggleOverview();
  });

  register("g", function() {
    return editorArea.goToSelected();
  });

  register("ctrl+s", function() {
    return workbench.editMenu.save();
  });

  register("shift+/", function() {
    return keyShortcutTip.show();
  });

  register("ctrl+c", function() {
    var $cloned, $selected, comp, html, uid;
    if (!sideDialog.isShowing() && !editorArea.isPreview()) {
      if (copyedComp.time !== void 0 && (Date.now() - copyedComp.time) < 1000) {
        return;
      }
      $selected = editorArea.selected();
      if ($selected.length === 0) {
        return;
      }
      uid = $selected.uid();
      comp = layoutComps.getComp($selected);
      $cloned = $selected.clone(true, true);
      $cloned.cleanUid();
      $cloned.removeClass("eve-selected");
      $cloned.find(layoutComps.selector).cleanUid();
      html = $("<div></div>").append($cloned).html();
      copyedComp = {
        time: Date.now(),
        id: uid,
        type: comp.type,
        html: html
      };
      return Essage.show({
        message: "" + comp.name + " copyed",
        status: "success"
      }, 1000);
    }
  });

  register("ctrl+v", function() {
    var $selected, canPutResult, pasteTarget;
    if (!sideDialog.isShowing() && !editorArea.isPreview()) {
      if (copyedComp.id === void 0) {
        return;
      }
      $selected = editorArea.selected();
      if ($selected.length === 0) {
        return;
      }
      pasteTarget = layoutComps.getComp($selected);
      if (copyedComp.comp === void 0) {
        copyedComp.comp = layoutComps.getComp($(copyedComp.html));
      }
      canPutResult = copyedComp.comp.canPutTo(pasteTarget);
      if (!canPutResult.can) {
        return Essage.show({
          message: canPutResult.msg,
          status: "error"
        }, 2000);
      } else {
        pasteTarget.add(copyedComp.comp, false, void 0);
        return copyedComp.comp = void 0;
      }
    }
  });

  editorArea.onLoad(function($inner) {
    $inner.keydown(function(evt) {
      return preventSomething(evt);
    });
    return $inner.keyup(function(evt) {
      return !shortcutHandler(evt, $inner);
    });
  });

  $(document).keydown(function(evt) {
    return preventSomething(evt);
  });

  $(document).keyup(function(evt) {
    return !shortcutHandler(evt);
  });

}).call(this);
;}});
this.require.define({"eevee/layout-components":function(exports, require, module){(function() {
  var BaseComp, C, Col, Component, Container, CustomCol, Grid, PagePart, Row, cache, converter, getComp, getCompByUID, innerScript, lazyload, sideDialog, store,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  require("eevee/extras/jquery.unique-id");

  store = require("eevee/store").store;

  sideDialog = require("eevee/side-dialog");

  innerScript = require("eevee/inner-script");

  converter = require("eevee/helpers/converter");

  lazyload = require("eevee/helpers/lazyload");

  C = require("eevee/c");

  cache = {};

  BaseComp = (function() {
    BaseComp.selector = ".eve-layout-comp";

    BaseComp.prototype.type = "BaseComp";

    BaseComp.prototype.isComp = true;

    function BaseComp($comp) {
      this.init($comp);
    }

    BaseComp.prototype.init = function($comp) {
      this.$comp = $comp;
      return cache[this.uid()] = this;
    };

    BaseComp.prototype.remove = function(callback) {
      if (this.isRoot()) {
        return;
      }
      return sideDialog.confirm("删除？", "确认删除么？当前组件内含的所有子组件也将会被一并删除。").done((function(_this) {
        return function() {
          cache[_this.uid()] = void 0;
          _this.$comp.remove();
          return typeof callback === "function" ? callback() : void 0;
        };
      })(this));
    };

    BaseComp.prototype.add = function(comp, prepend, anchor) {
      var $anchor, $target;
      $target = comp.isComp ? comp.$comp : comp;
      if (anchor) {
        $anchor = anchor.isComp ? anchor.$comp : anchor;
        if (prepend) {
          $anchor.before($target);
        } else {
          $anchor.after($target);
        }
      } else {
        if (prepend) {
          this.$comp.prepend($target);
        } else {
          this.$comp.append($target);
        }
      }
      this.$comp.cleanWhitespace();
      return $target.addClass("eve-animation");
    };

    BaseComp.prototype.isExist = function() {
      return this.$comp && this.$comp.length > 0;
    };

    BaseComp.prototype.is = function(target) {
      return this.$comp.is(target.$comp);
    };

    BaseComp.prototype.uid = function() {
      return this.$comp.uid();
    };

    BaseComp.prototype.isRoot = function() {
      return this.$comp.hasClass("eve-editable");
    };

    BaseComp.prototype.ancestors = function() {
      var result;
      result = _.map(this.$comp.parents(BaseComp.selector), function(parent) {
        return getComp($(parent));
      });
      result.unshift(this);
      return result;
    };

    BaseComp.prototype.parent = function() {
      var $parent;
      $parent = this.$comp.parent().closest(BaseComp.selector);
      if ($parent.length === 1) {
        return getComp($parent);
      } else {
        return void 0;
      }
    };

    BaseComp.prototype.children = function() {
      return _.map(this.$comp.children(BaseComp.selector), function(child) {
        return getComp($(child));
      });
    };

    BaseComp.prototype.bound = function(noMargin) {
      var height, left, mb, mbs, ml, mls, mr, mrs, mt, mts, px, top, width;
      top = this.$comp.offset().top;
      left = this.$comp.offset().left;
      width = this.$comp.innerWidth();
      height = this.$comp.innerHeight();
      px = /([\d\.]+)px/;
      mts = this.$comp.css("margin-top");
      mt = mts ? parseInt(px.exec(mts)[1]) : 0;
      mbs = this.$comp.css("margin-bottom");
      mb = mbs ? parseInt(px.exec(mbs)[1]) : 0;
      mls = this.$comp.css("margin-left");
      ml = mls ? parseInt(px.exec(mls)[1]) : 0;
      mrs = this.$comp.css("margin-right");
      mr = mrs ? parseInt(px.exec(mrs)[1]) : 0;
      return {
        top: noMargin ? top : top - mt,
        left: left,
        bottom: noMargin ? top + height : top + height + mb,
        right: left + width,
        width: width,
        height: height,
        mt: mt,
        mb: mb,
        ml: ml,
        mr: mr
      };
    };

    BaseComp.prototype.distance = function(x, y) {
      var b, bottomY, leftX, rightX, topY;
      b = this.bound();
      leftX = b.left - x;
      rightX = b.right - x;
      topY = b.top - y;
      bottomY = b.bottom - y;
      return {
        x: leftX * rightX < 0 ? -1 : Math.min(Math.abs(leftX), Math.abs(rightX)),
        y: topY * bottomY < 0 ? -1 : Math.min(Math.abs(topY), Math.abs(bottomY))
      };
    };

    return BaseComp;

  })();

  PagePart = (function(_super) {
    __extends(PagePart, _super);

    PagePart.selector = ".eve-header, .eve-body, .eve-footer";

    PagePart.prototype.type = "PagePart";

    function PagePart() {
      PagePart.__super__.constructor.apply(this, arguments);
      switch (/(eve-header)|(eve-body)|(eve-footer)/.exec(this.$comp.attr("class"))[0].slice(4)) {
        case "header":
          this.name = "页头";
          break;
        case "body":
          this.name = "内容";
          break;
        case "footer":
          this.name = "页脚";
      }
    }

    PagePart.prototype.closestPagePart = function() {
      return this;
    };

    PagePart.prototype.canPutTo = function(target) {
      return {
        can: false,
        msg: "页面块是顶级元素，不可放置到别的元素中"
      };
    };

    return PagePart;

  })(BaseComp);

  Container = (function(_super) {
    __extends(Container, _super);

    Container.selector = ".eve-container";

    Container.prototype.type = "Container";

    function Container(comp) {
      if (!comp) {
        comp = $("<div class=\"eve-container eve-layout-comp\"></div>");
      }
      Container.__super__.constructor.call(this, comp);
      this.name = "通栏";
    }

    Container.prototype.closestPagePart = function() {
      return getComp(this.$comp.closest(PagePart.selector));
    };

    Container.prototype.canPutTo = function(target) {
      var type;
      type = target.type;
      if (type !== "PagePart") {
        return {
          can: false,
          msg: "通栏只能放置到页面块中"
        };
      }
    };

    return Container;

  })(BaseComp);

  Grid = (function(_super) {
    __extends(Grid, _super);

    Grid.selector = ".eve-grid-8, .eve-grid-10, .eve-grid-12, .eve-grid-auto";

    Grid.prototype.type = "Grid";

    function Grid(comp) {
      var info;
      if (typeof comp !== "object") {
        if (comp === "auto") {
          this.cSize = "auto";
        } else {
          this.cSize = parseInt(comp);
          if (this.cSize !== 8 && this.cSize !== 10 && this.cSize !== 12) {
            throw "error size";
          }
        }
        comp = $("<div class=\"eve-grid-" + this.cSize + " eve-layout-comp\"></div>");
      }
      Grid.__super__.constructor.call(this, comp);
      if (/eve-grid-auto/.test(comp.attr("class"))) {
        this.name = "网格-自适应";
      } else {
        info = /eve-grid-(\d+)/.exec(comp.attr("class"));
        this.name = "网格-" + info[1];
        this._size = parseInt(info[1]) * C.UNIT_W;
      }
    }

    Grid.prototype.size = function() {
      if (this.cSize === "auto") {
        return this.$comp.width();
      } else {
        return this._size;
      }
    };

    Grid.prototype.closestGrid = function() {
      return this;
    };

    Grid.prototype.closestPagePart = function() {
      return getComp(this.$comp.closest(PagePart.selector));
    };

    Grid.prototype.canPutTo = function(target) {
      var type;
      type = target.type;
      if (!_.contains(["Container", "PagePart"], type)) {
        return {
          can: false,
          msg: "网格只能放置到通栏和页面块中"
        };
      }
    };

    return Grid;

  })(BaseComp);

  Row = (function(_super) {
    __extends(Row, _super);

    Row.selector = ".eve-row";

    Row.prototype.type = "Row";

    function Row(comp) {
      if (!comp) {
        comp = $("<div class=\"eve-row eve-layout-comp\"></div>");
      }
      Row.__super__.constructor.call(this, comp);
      this.name = "行";
    }

    Row.prototype.emptySpace = function() {
      var space;
      space = this.space() - this.size();
      if (space < 0) {
        return 0;
      } else {
        return space;
      }
    };

    Row.prototype.size = function() {
      var colSize, cuColSize;
      colSize = _.inject(this.$comp.children(Col.selector), function(sum, col) {
        return sum + getComp($(col)).size();
      }, 0);
      cuColSize = _.inject(this.$comp.children(CustomCol.selector), function(sum, col) {
        return sum + getComp($(col)).size();
      }, 0);
      return colSize + cuColSize;
    };

    Row.prototype.space = function() {
      var container, gridSize;
      container = this.closestCol();
      return gridSize = container && container.isExist() ? container.size() : this.closestGrid().size();
    };

    Row.prototype.closestCol = function() {
      return getComp(this.$comp.closest(Col.selector));
    };

    Row.prototype.closestRow = function() {
      return this;
    };

    Row.prototype.closestGrid = function() {
      return getComp(this.$comp.closest(Grid.selector));
    };

    Row.prototype.closestPagePart = function() {
      return getComp(this.$comp.closest(PagePart.selector));
    };

    Row.prototype.canPutTo = function(target) {
      var type;
      type = target.type;
      if (!_.contains(["Grid", "Col", "CustomCol"], type)) {
        return {
          can: false,
          msg: "行只能放置到网格和列中"
        };
      } else {
        if (this.size() > target.size()) {
          return {
            can: false,
            msg: "目标容器空间不够"
          };
        } else {
          return {
            can: true
          };
        }
      }
    };

    return Row;

  })(BaseComp);

  Col = (function(_super) {
    __extends(Col, _super);

    Col.selector = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map(function(i) {
      return ".eve-col-" + i;
    }).join(", ");

    Col.prototype.type = "Col";

    function Col(comp) {
      var info, size;
      if (typeof comp !== "object") {
        size = parseInt(comp);
        if (size > 12) {
          throw "error size";
        }
        comp = $("<div class=\"eve-col-" + size + " eve-layout-comp\"></div>");
      }
      Col.__super__.constructor.call(this, comp);
      info = /eve-col-(\d+)/.exec(comp.attr("class"));
      this.name = "列-" + info[1];
      this._size = parseInt(info[1]) * C.UNIT_W;
    }

    Col.prototype.changeSize = function(size) {
      var children, maxSize, minSize, realSize, width;
      realSize = size * C.UNIT_W;
      children = this.children();
      minSize = children && children.length > 0 ? _.max(children.map(function(comp) {
        return comp.size();
      })) : 100;
      maxSize = this.closestRow().emptySpace() + this._size;
      realSize = Math.max(minSize, Math.min(maxSize, realSize));
      size = realSize / C.UNIT_W;
      width = parseFloat(/(\d+)px/.exec(this.$comp.css("width"))[1]);
      if (width % C.UNIT_W !== 0) {
        this.$comp.css("width", width + realSize - this._size);
      }
      this.$comp.removeClass("eve-col-" + (this._size / C.UNIT_W)).addClass("eve-col-" + size);
      this._size = realSize;
      return this.name = "列-" + size;
    };

    Col.prototype.bound = function(noMargin) {
      var b;
      b = Col.__super__.bound.apply(this, arguments);
      if (!noMargin) {
        b.left -= b.ml;
        b.right += b.mr;
      }
      return b;
    };

    Col.prototype.size = function() {
      return this._size;
    };

    Col.prototype.closestCol = function() {
      return this;
    };

    Col.prototype.closestRow = function() {
      return getComp(this.$comp.closest(Row.selector));
    };

    Col.prototype.closestGrid = function() {
      return getComp(this.$comp.closest(Grid.selector));
    };

    Col.prototype.closestPagePart = function() {
      return getComp(this.$comp.closest(PagePart.selector));
    };

    Col.prototype.isInRow = function(row) {
      var _ref;
      return this.closestRow().$comp.is(((_ref = row.constructor) != null ? _ref.name : void 0) === "Row" ? row.$comp : $(row));
    };

    Col.prototype.canPutTo = function(target) {
      var type;
      type = target.type;
      if (type !== "Row") {
        return {
          can: false,
          msg: "列只能放到行中"
        };
      } else {
        if (target.emptySpace() < this.size()) {
          return {
            can: false,
            msg: "目标列空间不足"
          };
        } else {
          return {
            can: true
          };
        }
      }
    };

    return Col;

  })(BaseComp);

  CustomCol = (function(_super) {
    __extends(CustomCol, _super);

    CustomCol.selector = ".eve-col-cu";

    CustomCol.prototype.type = "CustomCol";

    function CustomCol(comp) {
      var size;
      if (typeof comp !== "object") {
        size = parseInt(comp);
        comp = $("<div class=\"eve-col-cu eve-layout-comp\" style=\"width:" + size + "px\"></div>");
      }
      CustomCol.__super__.constructor.call(this, comp);
      this.name = "列-自定义";
    }

    CustomCol.prototype.changeSize = function(size) {
      var children, maxSize, minSize;
      children = this.children();
      minSize = children && children.length > 0 ? _.max(children.map(function(comp) {
        return comp.size();
      })) : 1;
      maxSize = this.closestRow().emptySpace() + this.size();
      size = Math.max(minSize, Math.min(maxSize, size));
      this.$comp.css("width", size);
      return this._size = size;
    };

    CustomCol.prototype.size = function() {
      var b;
      b = this.bound();
      return b.right - b.left;
    };

    CustomCol.prototype.bound = function(noMargin) {
      var b;
      b = CustomCol.__super__.bound.apply(this, arguments);
      if (!noMargin) {
        b.left -= b.ml;
        b.right += b.mr;
      }
      return b;
    };

    CustomCol.prototype.closestCol = function() {
      return this;
    };

    CustomCol.prototype.closestRow = function() {
      return getComp(this.$comp.closest(Row.selector));
    };

    CustomCol.prototype.closestGrid = function() {
      return getComp(this.$comp.closest(Grid.selector));
    };

    CustomCol.prototype.closestPagePart = function() {
      return getComp(this.$comp.closest(PagePart.selector));
    };

    CustomCol.prototype.isInRow = function(row) {
      var _ref;
      return this.closestRow().$comp.is(((_ref = row.constructor) != null ? _ref.name : void 0) === "Row" ? row.$comp : $(row));
    };

    CustomCol.prototype.canPutTo = function(target) {
      var type;
      type = target.type;
      if (type !== "Row") {
        return {
          can: false,
          msg: "列只能放到行中"
        };
      } else {
        if (target.emptySpace() < this.size()) {
          return {
            can: false,
            msg: "目标列空间不足"
          };
        } else {
          return {
            can: true
          };
        }
      }
    };

    return CustomCol;

  })(BaseComp);

  Component = (function(_super) {
    __extends(Component, _super);

    Component.selector = ".eve-component";

    Component.prototype.type = "Component";

    function Component(comp, success, error) {
      if (typeof comp !== "object") {
        this.path = comp;
        this.reRender(success, error);
      } else {
        Component.__super__.constructor.call(this, comp);
      }
    }

    Component.prototype.init = function($comp) {
      var size;
      Component.__super__.init.apply(this, arguments);
      this.name = this.$comp.data("compName");
      this.path = this.$comp.data("compPath");
      this["class"] = this.$comp.data("compClass");
      return this._size = (size = this.$comp.data("compSize")) === "auto" ? 1 : size * C.UNIT_W;
    };

    Component.prototype.size = function() {
      return this._size;
    };

    Component.prototype.getTemplate = function(clone) {
      var $target, c, config, currentClass, customClass, originClass, style;
      if (!this.$comp) {
        return "{{inject \"" + this.path + "\"}}";
      } else {
        $target = clone ? this.$comp.clone(true) : this.$comp;
        config = $target.data("compData") || {};
        if (style = $target.attr("style")) {
          config["_STYLE_"] = style;
        } else {
          delete config["_STYLE_"];
        }
        $target.removeClass(["eve-layout-comp", "eve-selected", "eve-editing", "eve-animation"].join(" "));
        originClass = this["class"] ? this["class"].split(/\s+/) : [];
        currentClass = (c = $target.attr("class")) ? c.split(/\s+/) : [];
        customClass = currentClass.length === 0 ? [] : _.difference(currentClass, originClass);
        if (customClass.length > 0) {
          config["_CLASS_"] = customClass.join(" ");
        } else {
          delete config["_CLASS_"];
        }
        if (_.isEmpty(config)) {
          return "{{inject \"" + this.path + "\"}}";
        } else {
          return "{{#inject \"" + this.path + "\"}}" + (JSON.stringify(config)) + "{{/inject}}";
        }
      }
    };

    Component.prototype.getSavedData = function() {
      var savedData;
      savedData = {};
      savedData.template = this.getTemplate();
      savedData.gdata = this.$comp.data("compGData");
      savedData.path = this.path;
      return savedData;
    };

    Component.prototype.reRender = function(success, error) {
      var compGData, context, template;
      template = this.getTemplate(true);
      context = {
        template: template
      };
      if (store.mode === "ITEM") {
        context.spuId = store.spuId;
      } else if (store.mode === "SHOP") {
        context.sellerId = store.sellerId;
      }
      if (this.$comp) {
        compGData = this.$comp.data("compGData");
        if (compGData && _.size(compGData) > 0) {
          context.gdata = JSON.stringify(compGData);
        }
      }
      if (this.$comp) {
        this.$comp.spin();
      }
      return $.ajax({
        type: "POST",
        url: "/api/design/components/render",
        data: context,
        success: (function(_this) {
          return function(data) {
            var $newComp, oldUID, _ref;
            data = converter.data(data);
            oldUID = (_ref = _this.$comp) != null ? _ref.uid() : void 0;
            if (oldUID) {
              delete cache[oldUID];
            }
            $newComp = $(data);
            innerScript.require("pokeball/helpers/component").initializeByDom($newComp);
            lazyload.fake($newComp);
            if (_this.$comp) {
              _this.$comp.replaceWith($newComp);
            }
            _this.init($newComp);
            $newComp.addClass("eve-layout-comp");
            if (success) {
              return success.call(_this);
            }
          };
        })(this),
        error: (function(_this) {
          return function() {
            if (_this.$comp) {
              _this.$comp.spin(false);
            }
            if (error) {
              return error.call(_this);
            }
          };
        })(this)
      });
    };

    Component.prototype.canPutTo = function(target) {
      var type;
      type = target.type;
      if (!_.contains(["Grid", "Col", "CustomCol"], type)) {
        return {
          can: false,
          msg: "组件只能放置到网格和列中"
        };
      } else {
        if (this.size() > target.size()) {
          return {
            can: false,
            msg: "目标容器空间不够"
          };
        } else {
          return {
            can: true
          };
        }
      }
    };

    return Component;

  })(BaseComp);

  getComp = function($comp) {
    var $closestComp, comp;
    $closestComp = $comp.closest(BaseComp.selector);
    if ($closestComp.length > 0) {
      $comp = $closestComp;
    }
    if ($comp.length !== 1) {
      return void 0;
    }
    if (comp = cache[$comp.uid()]) {
      return comp;
    }
    if ($comp.is(PagePart.selector)) {
      return new PagePart($comp);
    } else if ($comp.is(Container.selector)) {
      return new Container($comp);
    } else if ($comp.is(Grid.selector)) {
      return new Grid($comp);
    } else if ($comp.is(Row.selector)) {
      return new Row($comp);
    } else if ($comp.is(Col.selector)) {
      return new Col($comp);
    } else if ($comp.is(CustomCol.selector)) {
      return new CustomCol($comp);
    } else if ($comp.is(Component.selector)) {
      return new Component($comp);
    }
  };

  getCompByUID = function(uid) {
    return cache[uid];
  };

  module.exports = {
    selector: BaseComp.selector,
    allSelector: [PagePart.selector, Container.selector, Grid.selector, Row.selector, Col.selector, CustomCol.selector, Component.selector].join(","),
    getComp: getComp,
    getCompByUID: getCompByUID,
    PagePart: PagePart,
    Container: Container,
    Grid: Grid,
    Row: Row,
    Col: Col,
    CustomCol: CustomCol,
    Component: Component
  };

}).call(this);
;}});
this.require.define({"eevee/layout-drag-drop":function(exports, require, module){(function() {
  var $innerDocument, DropCursor, componentMask, dragging, editorArea, handler, lastDragOverTime, layoutComps, overAndDrop, workbench;

  layoutComps = require("eevee/layout-components");

  workbench = require("eevee/workbench");

  editorArea = require("eevee/editor-area");

  componentMask = require("eevee/component-mask");

  dragging = void 0;

  lastDragOverTime = -1;

  $innerDocument = void 0;

  DropCursor = (function() {
    var get, template;
    get = function() {
      return $innerDocument.find(".eve-editor-drop-cursor");
    };
    template = Handlebars.templates["eevee/drop-cursor"];
    return {
      remove: function() {
        return get().remove();
      },
      show: function(vertical, position) {
        var $dropCursor;
        $dropCursor = get();
        if ($dropCursor.length === 0) {
          position.vertical = vertical;
          return $innerDocument.find("body").append(template(position));
        } else {
          if (vertical) {
            $dropCursor.addClass("vertical");
          } else {
            $dropCursor.removeClass("vertical");
          }
          return $dropCursor.css(position);
        }
      }
    };
  })();

  overAndDrop = function(evt, drop) {
    var row, source, target, targetType;
    source = dragging;
    target = layoutComps.getComp($(evt.currentTarget));
    if (target.$comp.parents(".eve-js-editable").length === 0) {
      return false;
    }
    targetType = target.type;
    switch (source.type) {
      case "Col":
        if (!_.contains(["Col", "CustomCol", "Row"], targetType)) {
          return false;
        }
        row = target.closestRow();
        if (!source.isInRow(row) && row.emptySpace() < source.size()) {
          evt.errorMessage = "目标行剩余空间不够容纳当前列。";
          return false;
        }
        if (targetType === "Col" || targetType === "CustomCol") {
          handler(source, target, evt, false, true, drop);
        } else {
          handler(source, target, evt, false, false, drop);
        }
        break;
      case "Row":
      case "Component":
        if (targetType === "Container" || targetType === "PagePart") {
          return false;
        }
        if (source.size() > target.size()) {
          evt.errorMessage = "目标容器宽度不够容纳当前行。";
          return false;
        }
        if (_.contains(["Col", "CustomCol", "Grid"], targetType)) {
          handler(source, target, evt, true, false, drop);
        } else {
          handler(source, target, evt, true, true, drop);
        }
        break;
      case "Grid":
        if (!_.contains(["Grid", "Container", "PagePart"], targetType)) {
          return false;
        }
        if (targetType === "Grid") {
          handler(source, target, evt, true, true, drop);
        } else {
          handler(source, target, evt, true, false, drop);
        }
        break;
      case "Container":
        if (!_.contains(["Grid", "Container", "PagePart"], targetType)) {
          return false;
        }
        if (targetType === "Grid" || targetType === "Container") {
          handler(source, target, evt, true, true, drop);
        } else {
          handler(source, target, evt, true, false, drop);
        }
    }
    return true;
  };

  handler = function(source, target, evt, vertical, sibling, drop) {
    var before, bound, child, children, closest, closestDistance, distance, isClose, isLeft, isTop, mouseX, mouseY, position;
    mouseX = evt.originalEvent.clientX + $innerDocument.scrollLeft();
    mouseY = evt.originalEvent.clientY + $innerDocument.scrollTop();
    children = target.children();
    target = (function() {
      var _i, _len;
      if (children.length > 0 && !sibling) {
        sibling = true;
        closest = void 0;
        closestDistance = void 0;
        for (_i = 0, _len = children.length; _i < _len; _i++) {
          child = children[_i];
          if (!closest) {
            closest = child;
            closestDistance = child.distance(mouseX, mouseY);
            continue;
          }
          distance = child.distance(mouseX, mouseY);
          isClose = vertical ? distance.y < closestDistance.y : distance.x < closestDistance.x;
          if (isClose) {
            closest = child;
            closestDistance = distance;
          } else {
            break;
          }
        }
        return closest;
      } else {
        return target;
      }
    })();
    bound = target.bound();
    isTop = mouseY < (bound.top + bound.bottom) / 2;
    isLeft = mouseX < (bound.left + bound.right) / 2;
    before = vertical ? isTop : isLeft;
    if (drop) {
      source.$comp.find(".eve-animation").removeClass("eve-animation");
      if (sibling) {
        if (before) {
          source.$comp.insertBefore(target.$comp);
        } else {
          source.$comp.insertAfter(target.$comp);
        }
      } else {
        target.$comp.append(source.$comp);
      }
      return source.$comp.addClass("eve-animation");
    } else {
      position = sibling ? vertical ? {
        top: before ? bound.top : bound.bottom,
        left: bound.left,
        width: bound.right - bound.left
      } : {
        top: bound.top,
        left: before ? bound.left : bound.right,
        height: bound.bottom - bound.top
      } : vertical ? {
        top: bound.top + 4,
        left: bound.left + 8,
        width: bound.right - bound.left - 16
      } : {
        top: bound.top + 8,
        left: bound.left + 4,
        height: bound.bottom - bound.top - 16
      };
      return DropCursor.show(!vertical, position);
    }
  };

  editorArea.onLoad(function($_innerDocument) {
    $innerDocument = $_innerDocument;
    $innerDocument.on("dragstart", layoutComps.selector, function(evt) {
      evt.stopPropagation();
      componentMask.ignoreRealHover(true);
      componentMask.setHoverTarget(void 0);
      return dragging = layoutComps.getComp($(evt.currentTarget));
    });
    $innerDocument.on("dragend", layoutComps.selector, function(evt) {
      evt.stopPropagation();
      workbench.configPanel.show();
      componentMask.ignoreRealHover(false);
      componentMask.setHoverTarget(void 0);
      DropCursor.remove();
      return dragging = void 0;
    });
    $innerDocument.on("dragover", layoutComps.selector, function(evt) {
      var canHandle, clientY, currentTime;
      evt.preventDefault();
      currentTime = Date.now();
      if (currentTime - lastDragOverTime < 100) {
        evt.stopPropagation();
        return;
      } else {
        lastDragOverTime = currentTime;
      }
      clientY = evt.originalEvent.clientY;
      if (clientY < ((workbench.editMenu.get().height() + 50) * (editorArea.isOverview() ? 2 : 1))) {
        $innerDocument.scrollTop($innerDocument.scrollTop() - 50);
      }
      if (clientY > (($(window).height() - 50) * (editorArea.isOverview() ? 2 : 1))) {
        $innerDocument.scrollTop($innerDocument.scrollTop() + 50);
      }
      canHandle = overAndDrop(evt, false);
      if (!canHandle && !$(this).parents().is(layoutComps.selector)) {
        DropCursor.remove();
        componentMask.setHoverTarget(void 0);
      }
      if (canHandle) {
        evt.stopPropagation();
        return componentMask.setHoverTarget($(evt.currentTarget));
      }
    });
    return $innerDocument.on("drop", layoutComps.selector, function(evt) {
      var success;
      evt.preventDefault();
      success = overAndDrop(evt, true);
      if (!success && !$(this).parents().is(layoutComps.selector)) {
        if (evt.errorMessage) {
          Essage.show({
            message: evt.errorMessage,
            status: "warning"
          }, 3000);
        }
      }
      if (success) {
        return evt.stopPropagation();
      }
    });
  });

}).call(this);
;}});
this.require.define({"eevee/layout-editable":function(exports, require, module){(function() {
  var app, configPanel, crumbs, editMenu, editorArea, group, layoutComps, store, url, workbench, _ref;

  layoutComps = require("eevee/layout-components");

  workbench = require("eevee/workbench");

  editorArea = require("eevee/editor-area");

  _ref = require("eevee/store"), store = _ref.store, group = _ref.group, app = _ref.app;

  require("eevee/key-shortcut");

  require("eevee/layout-drag-drop");

  require("eevee/component-mask");

  editMenu = workbench.editMenu;

  crumbs = workbench.crumbs;

  configPanel = workbench.configPanel;

  $(window).on("beforeunload", function(evt) {
    return "离开此页会导致当前所有未保存的修改丢失！";
  });

  editorArea.onSelect(function($inner, $comp) {
    var comp, crumbList;
    comp = layoutComps.getComp($comp);
    crumbList = _.chain(comp.ancestors().reverse()).map(function(parent) {
      if (parent.$comp.closest(".eve-editable").length > 0) {
        return {
          uid: parent.uid(),
          name: parent.name
        };
      } else {
        return void 0;
      }
    }).compact().value();
    crumbs.show(crumbList);
    return configPanel.init(comp);
  });

  editorArea.onUnSelect(function($inner) {
    crumbs.empty();
    return configPanel.destory();
  });

  if (store.demo) {
    editorArea.setUrl("/editor-area.html");
  } else {
    if (group !== void 0 && app !== void 0) {
      url = "/design/pages/group/" + group + "/app/" + app;
    } else {
      url = "/design/pages";
    }
    switch (store.mode) {
      case "ITEM":
        if (store.pageUrl) {
          editorArea.setUrl("" + url + "?path=" + store.pageUrl + "&isSite=true&itemId=" + store.itemId + "&spuId=" + store.spuId);
        } else {
          editorArea.setUrl("" + url + "?instanceId=" + store.site.releaseInstanceId + "&path=detail&isSite=true&itemId=" + store.itemId + "&spuId=" + store.spuId);
        }
        break;
      case "ITEM_TEMPLATE":
        editorArea.setUrl("" + url + "?instanceId=" + store.site.releaseInstanceId + "&path=detail&isSite=false&spuId=" + store.spuId);
        break;
      default:
        if (store.currentPage) {
          editorArea.setUrl("" + url + "?instanceId=" + store.instance.id + "&path=" + store.currentPage.path + "&isSite=" + store.isSite);
        }
    }
  }

}).call(this);
;}});
this.require.define({"eevee/page-list":function(exports, require, module){(function() {
  var app, converter, editorArea, get, group, sideDialog, store, _ref;

  sideDialog = require("eevee/side-dialog");

  editorArea = require("eevee/editor-area");

  converter = require("eevee/helpers/converter");

  _ref = require("eevee/store"), store = _ref.store, group = _ref.group, app = _ref.app;

  get = function() {
    return $(".page-list-container");
  };

  get().on("click", ".js-page-set-index", function() {
    var pagePath;
    pagePath = $(this).closest("li").data("pagePath");
    get().spin();
    $.ajax({
      type: "POST",
      url: "/api/design/pages/set-index?_method=PUT",
      data: {
        instanceId: store.instance.id,
        path: pagePath
      },
      success: (function(_this) {
        return function() {
          return $(_this).closest("li").addClass("page-index").siblings().removeClass("page-index");
        };
      })(this),
      complete: function() {
        return get().spin(false);
      }
    });
    return false;
  });

  get().on("click", ".js-page-new", function() {
    sideDialog.show({
      title: "新增页面",
      content: Handlebars.templates["eevee/page-config"]({
        newPage: true
      }),
      noAutoClose: true
    }, function($dialog) {
      return $("#js-page-form").submit(function() {
        var pageConfig;
        pageConfig = $(this).serializeObject();
        store.pages = store.pages || {};
        if (store.pages[pageConfig.path]) {
          Essage.show({
            message: "路径已存在，请重新输入一个新的路径",
            status: "error"
          }, 3000);
          return false;
        }
        pageConfig.instanceId = store.instance.id;
        $.ajax({
          type: "POST",
          url: "/api/design/pages",
          data: pageConfig,
          success: function(data) {
            var $pagesLi, newPage;
            data = converter.data(data);
            newPage = {
              id: data,
              instanceId: store.instance.id,
              name: pageConfig.name,
              path: pageConfig.path,
              keywords: pageConfig.keywords,
              description: pageConfig.description,
              isIndex: store.indexPage === void 0 && pageConfig.path === "index"
            };
            store.pages[newPage.path] = newPage;
            $(".page-list").prepend(Handlebars.templates["eevee/page-list-line"](newPage));
            sideDialog.close();
            $pagesLi = $(".page-list > li");
            if ($pagesLi.length === 1) {
              return $($pagesLi[0]).click();
            }
          }
        });
        return false;
      });
    });
    return false;
  });

  get().on("click", ".js-page-setting", function() {
    var $pageLi, content, page, url;
    $pageLi = $(this).closest("li");
    page = store.pages[$pageLi.data("pagePath")];
    if (store.mode === "SHOP") {
      content = Handlebars.templates["eevee/page-config"]({
        newPage: false,
        inShop: true,
        page: page
      });
      url = "/api/design/pages/shop/" + page.id;
    } else {
      content = Handlebars.templates["eevee/page-config"]({
        newPage: false,
        page: page
      });
      url = "/api/design/pages/" + page.id;
    }
    sideDialog.show({
      title: "修改页面信息",
      content: content,
      noAutoClose: true
    }, function($dialog) {
      return $("#js-page-form").submit(function() {
        var pageConfig;
        pageConfig = $(this).serializeObject();
        if (pageConfig.path !== page.path && store.pages[pageConfig.path]) {
          Essage.show({
            message: "路径已存在，请重新输入一个新的路径",
            status: "error"
          }, 3000);
          return false;
        }
        $.ajax({
          type: "POST",
          url: "" + url + "?_method=PUT",
          data: pageConfig,
          success: function() {
            var showData;
            delete store.pages[page.path];
            if (store.mode !== "SHOP") {
              page.path = pageConfig.path;
              page.name = pageConfig.name;
            }
            page.keywords = pageConfig.keywords;
            page.description = pageConfig.description;
            store.pages[page.path] = page;
            showData = {
              id: page.id,
              path: page.path,
              name: page.name,
              isIndex: $pageLi.hasClass("page-index"),
              isCurrent: $pageLi.hasClass("page-current"),
              mode: store.mode
            };
            $pageLi.replaceWith(Handlebars.templates["eevee/page-list-line"](showData));
            return sideDialog.close();
          }
        });
        return false;
      });
    });
    return false;
  });

  get().on("click", ".js-page-delete", function() {
    var $pageLi, page;
    $pageLi = $(this).closest("li");
    page = store.pages[$pageLi.data("pagePath")];
    sideDialog.confirm("删除页面", "确认删除页面吗？删除后将无法恢复，页面内已装修的内容都将丢失。").done(function() {
      get().spin();
      return $.ajax({
        type: "POST",
        url: "/api/design/pages/" + page.id + "?_method=DELETE",
        success: function() {
          var $nextPageLi;
          $nextPageLi = $pageLi.next();
          if ($nextPageLi.length === 0) {
            $nextPageLi = $pageLi.prev();
          }
          $pageLi.remove();
          delete store.pages[page.path];
          if (store.currentPage.path === page.path) {
            store.currentPage = void 0;
            if ($nextPageLi.length > 0) {
              return $nextPageLi.click();
            } else {
              return editorArea.clean();
            }
          }
        },
        complete: function() {
          return get().spin(false);
        }
      });
    });
    return false;
  });

  get().on("click", ".page-list > li", function() {
    var pagePath, url;
    pagePath = $(this).data("pagePath");
    if (store.currentPage && store.currentPage.path === pagePath) {
      return;
    }
    if (editorArea.inner()) {
      if (!confirm("切换页面会导致当前页未保存的内容丢失，确认切换到另一个页面么？")) {
        return;
      }
    }
    $(this).addClass("page-current").siblings().removeClass("page-current");
    store.currentPage = store.pages[pagePath];
    if (editorArea.inner()) {
      editorArea.unSelect();
    }
    if (group !== void 0 && app !== void 0) {
      url = "/design/pages/group/" + group + "/app/" + app;
    } else {
      url = "/design/pages";
    }
    editorArea.setUrl("" + url + "?instanceId=" + store.instance.id + "&path=" + store.currentPage.path + "&isSite=" + store.isSite);
    return false;
  });

  module.exports = {
    toggle: function() {
      return $(".editor-main").toggleClass("page-list-pull-left");
    }
  };

}).call(this);
;}});
this.require.define({"eevee/part-manager":function(exports, require, module){(function() {
  var editorArea, getExists, sideDialog, template, toggle;

  editorArea = require("eevee/editor-area");

  sideDialog = require("eevee/side-dialog");

  template = Handlebars.templates["eevee/part-manager"];

  getExists = function() {
    var exists;
    exists = _.chain(editorArea.inner().find(".eve-part")).map(function(p) {
      var key;
      key = $(p).data("partKey");
      if (key === void 0) {
        return void 0;
      } else {
        return key.toString();
      }
    }).compact().value();
    if (exists.length === 0) {
      return void 0;
    } else {
      return exists;
    }
  };

  toggle = function($target) {
    var exists;
    if ($target.hasClass("eve-part")) {
      return $target.removeClass("eve-part");
    } else {
      exists = getExists();
      return sideDialog.show({
        title: "标记编辑区域",
        content: template({
          exists: exists,
          key: $target.data("partKey")
        }),
        noAutoClose: true
      }, function($dialog) {
        return $("#js-part-form").submit(function() {
          var value;
          value = $(this).serializeObject().key;
          if (value === void 0 || value === "") {
            Essage.show({
              message: "key 不能为空",
              status: "error"
            }, 2000);
            return false;
          }
          if (exists !== void 0 && _.indexOf(exists, value) !== -1) {
            Essage.show({
              message: "key 不能重复，请重新填写一个不存在的 key",
              status: "error"
            }, 2000);
            return false;
          }
          $target.find(".eve-part").removeClass("eve-part");
          $target.addClass("eve-part").attr("data-part-key", value);
          sideDialog.close();
          return false;
        });
      });
    }
  };

  module.exports = {
    toggle: toggle
  };

}).call(this);
;}});
this.require.define({"eevee/side-dialog":function(exports, require, module){(function() {
  var alert, cancel, close, confirm, dialogTemplate, disableCover, isShowing, ok, rootTemplate, show;

  disableCover = "<div class=\"side-dialog-disable-cover\"></div>";

  rootTemplate = Handlebars.templates["eevee/dialog/root"];

  dialogTemplate = Handlebars.templates["eevee/dialog/dialog"];

  show = function(config, callback) {
    var $dialog, content, deferred;
    if (isShowing()) {
      return;
    }
    if (typeof config !== "object") {
      content = config;
      config.content = content;
    }
    config.callback = config.callback || callback;
    $(".editor").addClass("pull-left");
    $("body").append(disableCover);
    $dialog = $(rootTemplate(config));
    $dialog.appendTo("body");
    deferred = $.Deferred();
    $dialog.on("dialog-cancel", function() {
      close();
      return deferred.reject($dialog);
    });
    $dialog.on("dialog-ok", function() {
      if (!config.noAutoClose) {
        close();
      }
      return deferred.resolve($dialog);
    });
    $(".js-dialog-cancel", $dialog).off("click").click(function() {
      $dialog.trigger("dialog-cancel");
      return false;
    });
    $(".js-dialog-ok", $dialog).off("click").click(function() {
      $dialog.trigger("dialog-ok");
      return false;
    });
    if (typeof config.callback === "function") {
      config.callback($dialog, deferred);
    }
    return deferred.promise();
  };

  ok = function() {
    return $(".side-dialog:last").trigger("dialog-ok");
  };

  cancel = function() {
    return $(".side-dialog:last").trigger("dialog-cancel");
  };

  isShowing = function() {
    return $(".side-dialog").length > 0;
  };

  close = function() {
    $(".editor").removeClass("pull-left");
    $(".side-dialog-disable-cover:last").remove();
    return $(".side-dialog:last").remove();
  };

  confirm = function(title, info, icon) {
    var config, content;
    content = {
      info: info,
      iconClass: icon,
      confirm: true
    };
    config = {
      title: title,
      content: dialogTemplate(content)
    };
    return show(config);
  };

  alert = function(title, info, icon) {
    var config, content;
    content = {
      info: info,
      iconClass: icon,
      confirm: false
    };
    config = {
      title: title,
      content: dialogTemplate(content)
    };
    return show(config);
  };

  module.exports = {
    show: show,
    isShowing: isShowing,
    confirm: confirm,
    alert: alert,
    ok: ok,
    cancel: cancel,
    close: close
  };

}).call(this);
;}});
this.require.define({"eevee/store":function(exports, require, module){(function() {
  var app, data, group;

  data = $("body").data("editorContext") || {};

  group = $("body").data("group");

  app = $("body").data("app");

  data.demo = $("body").data("demo");

  if (data.demo) {
    data.mode = "TEMPLATE";
    data.isSite = false;
  } else {
    data.isSite = data.mode === "SHOP" || data.mode === "ITEM" || data.mode === "ITEM-TEMPLATE";
  }

  module.exports = {
    store: data,
    group: group,
    app: app
  };

}).call(this);
;}});
this.require.define({"eevee/workbench":function(exports, require, module){(function() {
  var childrenAppender, componentMask, configComps, configPanel, crumbs, editMenu, editorArea, keyShortcutTip, layoutComps, pageList, partManager, sideDialog, store;

  layoutComps = require("eevee/layout-components");

  configComps = require("eevee/config/layout-components");

  editorArea = require("eevee/editor-area");

  store = require("eevee/store").store;

  sideDialog = require("eevee/side-dialog");

  childrenAppender = require("eevee/children-appender");

  componentMask = require("eevee/component-mask");

  keyShortcutTip = require("eevee/key-shortcut-tip");

  partManager = require("eevee/part-manager");

  pageList = require("eevee/page-list");

  editMenu = (function() {
    var $innerDocument, get;
    $innerDocument = void 0;
    get = function() {
      return $(".editor-menu");
    };
    $(".editor-show-key-shortcut").click(function() {
      keyShortcutTip.show();
      return false;
    });
    $(".js-page-preview").change(function() {
      if (!editorArea.inner()) {
        $(this).prop("checked", !$(this).prop("checked"));
        return;
      }
      if ($(this).prop("checked")) {
        configPanel.hide();
      } else {
        configPanel.show();
      }
      return editorArea.togglePreview();
    });
    $(".js-page-overview").change(function() {
      return editorArea.toggleOverview();
    });
    $(".js-page-save").click(function() {
      if (!editorArea.inner()) {
        return;
      }
      return editorArea.save();
    });
    $(".js-page-list").change(function() {
      return pageList.toggle();
    });
    editorArea.onLoad(function($inner) {
      return $innerDocument = $inner;
    });
    return {
      get: get,
      togglePreview: function() {
        return $(".js-page-preview").click();
      },
      toggleOverview: function() {
        return $(".js-page-overview").click();
      },
      togglePageList: function() {
        return $(".js-page-list").click();
      },
      save: function() {
        return $(".js-page-save").click();
      }
    };
  })();

  crumbs = (function() {
    var template;
    $(".editor-menu").on({
      click: function() {
        return layoutComps.getCompByUID($(this).data("compUid")).$comp.click();
      },
      mouseenter: function() {
        return componentMask.setHoverTarget(layoutComps.getCompByUID($(this).data("compUid")).$comp);
      },
      mouseleave: function() {
        return componentMask.setHoverTarget(void 0);
      }
    }, ".editor-menu-crumbs .crumb");
    template = Handlebars.templates["eevee/crumbs"];
    return {
      get: function() {
        return $(".editor-menu-crumbs");
      },
      empty: function() {
        return this.get().empty();
      },
      show: function(crumbs) {
        return this.get().replaceWith(template(crumbs));
      }
    };
  })();

  configPanel = (function() {
    var current, get, toolbarTemplate;
    toolbarTemplate = Handlebars.templates["eevee/toolbar"];
    Handlebars.registerPartial("field-group", Handlebars.templates["eevee/field-group"]);
    Handlebars.registerPartial("form-generator", Handlebars.templates["eevee/form-generator"]);
    get = function() {
      return $(".editor-config-panel");
    };
    get().on("click", ".editor-config-toolbar a", function(evt) {
      var comp;
      if ($(this).hasClass("eve-disabled")) {
        return false;
      }
      if (editorArea.selected().length === 0) {
        return false;
      }
      comp = layoutComps.getComp(editorArea.selected());
      switch ($(this).data("action")) {
        case "position":
          editorArea.goToSelected();
          break;
        case "delete":
          comp.remove(function() {
            return editorArea.unSelect();
          });
          break;
        case "add":
          childrenAppender(comp, evt.shiftKey);
          break;
        case "add-before":
          childrenAppender(comp.parent(), true, comp);
          break;
        case "add-after":
          childrenAppender(comp.parent(), false, comp);
          break;
        case "togglePart":
          partManager.toggle(comp.$comp);
          break;
        case "unSelect":
          editorArea.unSelect();
      }
      return false;
    });
    current = void 0;
    return {
      get: get,
      getParts: function() {
        return $(".editor-config-parts");
      },
      getToolbar: function() {
        return $(".editor-config-toolbar");
      },
      show: function() {
        if (current) {
          $(".editor-main").addClass("config-panel-pull-left");
          return this.get().removeClass("hide");
        }
      },
      hide: function() {
        $(".editor-main").removeClass("config-panel-pull-left");
        return this.get().addClass("hide");
      },
      init: function(comp) {
        var toolbarConfig;
        toolbarConfig = {
          editable: comp.$comp.hasClass("eve-editable"),
          isRoot: comp.parent() === void 0,
          isComponent: comp.type === "Component",
          isCanPart: (function() {
            var pagePart;
            if (store.mode !== "TEMPLATE") {
              return false;
            }
            pagePart = typeof comp.closestPagePart === "function" ? comp.closestPagePart() : void 0;
            return pagePart && pagePart.name === "内容";
          })(),
          isInPart: comp.$comp.parents(".eve-part").length > 0
        };
        this.getToolbar().replaceWith(toolbarTemplate(toolbarConfig));
        current = configComps.getConfig(comp);
        this.getParts().replaceWith(current.render());
        if (typeof current.init === "function") {
          current.init(this.getParts());
        }
        return this.show();
      },
      destory: function() {
        this.hide();
        if (current) {
          if (typeof current.destory === "function") {
            current.destory(this.getParts());
          }
          return current = void 0;
        }
      }
    };
  })();

  module.exports = {
    editMenu: editMenu,
    crumbs: crumbs,
    configPanel: configPanel
  };

}).call(this);
;}});
(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
  templates["eevee/components/children"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, helperMissing=helpers.helperMissing, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    ";
  stack1 = helpers.each.call(depth0, depth0, {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  stack1 = helpers.unless.call(depth0, (data == null || data === false ? data : data.last), {hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n      <li class=\"";
  if (helper = helpers['class']) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0['class']); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" data-data=\""
    + escapeExpression((helper = helpers.json || (depth0 && depth0.json),options={hash:{},data:data},helper ? helper.call(depth0, (depth0 && depth0.data), options) : helperMissing.call(depth0, "json", (depth0 && depth0.data), options)))
    + "\">\n        <h3>";
  if (helper = helpers.title) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.title); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</h3>\n        <p>";
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</p>\n      </li>\n    ";
  return buffer;
  }

function program4(depth0,data) {
  
  
  return "\n    <li class=\"separater\"></li>\n    ";
  }

  buffer += "<ul class=\"comp-add-list\">\n  ";
  stack1 = helpers.each.call(depth0, depth0, {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>\n";
  return buffer;
  });
templates["eevee/config-panel"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); partials = this.merge(partials, Handlebars.partials); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "<p>"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.baseInfo)),stack1 == null || stack1 === false ? stack1 : stack1.description)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</p>";
  return buffer;
  }

function program3(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n    <div class=\"field-group\" data-description=\"";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.description), {hash:{},inverse:self.program(6, program6, data),fn:self.program(4, program4, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n      <span class=\"field-group-label\">";
  if (helper = helpers.label) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.label); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + ":</span><span class=\"field-group-content\">";
  if (helper = helpers.value) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.value); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</span>\n    </div>\n    ";
  return buffer;
  }
function program4(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program6(depth0,data) {
  
  
  return "基本信息";
  }

function program8(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n  <li>\n    ";
  stack1 = self.invokePartial(partials['form-generator'], 'form-generator', depth0, helpers, partials, data);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  </li>\n  ";
  return buffer;
  }

  buffer += "<ul class=\"editor-config-parts\">\n  <li>\n    <h2>"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.baseInfo)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</h2>\n    ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.baseInfo)),stack1 == null || stack1 === false ? stack1 : stack1.description), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.baseInfo)),stack1 == null || stack1 === false ? stack1 : stack1.props), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  </li>\n  ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.configs), {hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>\n";
  return buffer;
  });
templates["eevee/crumbs"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n  <li><i class=\"fa fa-chevron-right\"></i></li>\n  <li class=\"crumb\" data-comp-uid=\"";
  if (helper = helpers.uid) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.uid); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</li>\n  ";
  return buffer;
  }

  buffer += "<ul class=\"editor-menu-crumbs\">\n  ";
  stack1 = helpers.each.call(depth0, depth0, {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>\n";
  return buffer;
  });
templates["eevee/dialog/dialog"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "<i class=\"";
  if (helper = helpers.iconClass) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.iconClass); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\"></i>";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "\n  <button class=\"big js-dialog-cancel\"><i class=\"fa fa-circle-o\"></i>&nbsp;取消</button>\n  ";
  }

  stack1 = helpers['if'].call(depth0, (depth0 && depth0.iconClass), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n<p>";
  if (helper = helpers.info) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.info); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</p>\n<div class=\"side-dialog-control\">\n  <button class=\"big js-dialog-ok\"><i class=\"fa fa-check\"></i>&nbsp;确定</button>\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.confirm), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n";
  return buffer;
  });
templates["eevee/dialog/root"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"side-dialog\">\n  <a class=\"large side-dialog-close js-dialog-cancel\" href=\"#\">关闭</a>\n  <h1>";
  if (helper = helpers.title) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.title); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</h1>\n  <div class=\"side-dialog-content\">\n    ";
  if (helper = helpers.content) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.content); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  </div>\n</div>\n";
  return buffer;
  });
templates["eevee/drop-cursor"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  
  return "eve-editor-drop-cursor-vertical";
  }

function program3(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "width: ";
  if (helper = helpers.width) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.width); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "px;";
  return buffer;
  }

function program5(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "height: ";
  if (helper = helpers.height) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.height); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "px;";
  return buffer;
  }

function program7(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "top: ";
  if (helper = helpers.top) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.top); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "px;";
  return buffer;
  }

function program9(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "left: ";
  if (helper = helpers.left) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.left); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "px;";
  return buffer;
  }

  buffer += "<div class=\"eve-editor-drop-cursor ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.vertical), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" style=\"\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.width), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.height), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.top), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.left), {hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\">\n</div>\n";
  return buffer;
  });
templates["eevee/extras/login"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<p>您的登录似乎已经超时，请重新登录。</p>\n<form action=\"\" id=\"js-login-form\">\n  <input type=\"hidden\" name=\"type\" value=\"3\">\n  <div class=\"field-group\">\n    <span class=\"field-group-label\">用户名: </span>\n    <input type=\"text\" name=\"loginId\">\n  </div>\n  <div class=\"field-group\">\n    <span class=\"field-group-label\">密码: </span>\n    <input type=\"password\" name=\"password\">\n  </div>\n</form>\n<div class=\"side-dialog-control\">\n  <button type=\"submit\" class=\"big\" form=\"js-login-form\"><i class=\"fa fa-sign-in\"></i>&nbsp;登录</button>\n</div>\n";
  });
templates["eevee/extras/spinner"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  
  return "full-window";
  }

function program3(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "<div class=\"message\">";
  if (helper = helpers.message) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.message); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</div>";
  return buffer;
  }

  buffer += "<div class=\"eevee-spinner ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.isWindow), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n  <div class=\"spinner\">\n    <div></div>\n    <div></div>\n    <div></div>\n    <div></div>\n    <div></div>\n  </div>\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.message), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n";
  return buffer;
  });
templates["eevee/field-group"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var stack1, helper;
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  return escapeExpression(stack1);
  }

function program3(depth0,data) {
  
  
  return "组件设置";
  }

function program5(depth0,data) {
  
  
  return "（全局）";
  }

function program7(depth0,data) {
  
  
  return "style=\"display:none;\"";
  }

function program9(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "<span class=\"field-group-label\">";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.global), {hash:{},inverse:self.noop,fn:self.program(10, program10, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  if (helper = helpers.label) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.label); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + ":</span>";
  return buffer;
  }
function program10(depth0,data) {
  
  
  return "<i class=\"fa fa-globe\"></i> ";
  }

function program12(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n    <input type=\"text\" name=\"";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" value=\"";
  if (helper = helpers.value) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.value); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0['class']), {hash:{},inverse:self.noop,fn:self.program(13, program13, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n    ";
  return buffer;
  }
function program13(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "class=\"";
  if (helper = helpers['class']) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0['class']); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\"";
  return buffer;
  }

function program15(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n    <textarea name=\"";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0['class']), {hash:{},inverse:self.noop,fn:self.program(13, program13, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">";
  if (helper = helpers.value) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.value); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</textarea>\n    ";
  return buffer;
  }

function program17(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n      ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.options), {hash:{},inverse:self.noop,fn:self.programWithDepth(18, program18, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  return buffer;
  }
function program18(depth0,data,depth1) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n      <label><input type=\"radio\" name=\""
    + escapeExpression(((stack1 = (depth1 && depth1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" value=\""
    + escapeExpression(((stack1 = (data == null || data === false ? data : data.key)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" ";
  stack1 = (helper = helpers.equals || (depth1 && depth1.equals),options={hash:{},inverse:self.noop,fn:self.program(19, program19, data),data:data},helper ? helper.call(depth0, (data == null || data === false ? data : data.key), (depth1 && depth1.value), options) : helperMissing.call(depth0, "equals", (data == null || data === false ? data : data.key), (depth1 && depth1.value), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " ";
  stack1 = helpers['if'].call(depth0, (depth1 && depth1['class']), {hash:{},inverse:self.noop,fn:self.programWithDepth(21, program21, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">";
  stack1 = (typeof depth0 === functionType ? depth0.apply(depth0) : depth0);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</label>\n      ";
  return buffer;
  }
function program19(depth0,data) {
  
  
  return "checked";
  }

function program21(depth0,data,depth1) {
  
  var buffer = "", stack1;
  buffer += "class=\""
    + escapeExpression(((stack1 = (depth1 && depth1['class'])),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\"";
  return buffer;
  }

function program23(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n    <label><input type=\"checkbox\" name=\"";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" value=\"true\" ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.value), {hash:{},inverse:self.noop,fn:self.program(19, program19, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0['class']), {hash:{},inverse:self.noop,fn:self.program(13, program13, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "></label>\n    ";
  return buffer;
  }

function program25(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n    <select name=\"";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0['class']), {hash:{},inverse:self.noop,fn:self.program(13, program13, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n      ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.options), {hash:{},inverse:self.noop,fn:self.programWithDepth(26, program26, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </select>\n    ";
  return buffer;
  }
function program26(depth0,data,depth1) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n      <option value=\""
    + escapeExpression(((stack1 = (data == null || data === false ? data : data.key)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" ";
  stack1 = (helper = helpers.equals || (depth1 && depth1.equals),options={hash:{},inverse:self.noop,fn:self.program(27, program27, data),data:data},helper ? helper.call(depth0, (data == null || data === false ? data : data.key), (depth1 && depth1.value), options) : helperMissing.call(depth0, "equals", (data == null || data === false ? data : data.key), (depth1 && depth1.value), options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">";
  stack1 = (typeof depth0 === functionType ? depth0.apply(depth0) : depth0);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</option>\n      ";
  return buffer;
  }
function program27(depth0,data) {
  
  
  return "selected";
  }

function program29(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n      ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.options), {hash:{},inverse:self.noop,fn:self.programWithDepth(30, program30, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  return buffer;
  }
function program30(depth0,data,depth1) {
  
  var buffer = "", stack1;
  buffer += "\n      <button type=\"button\" name=\""
    + escapeExpression(((stack1 = (depth1 && depth1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" value=\""
    + escapeExpression(((stack1 = (data == null || data === false ? data : data.key)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" ";
  stack1 = helpers['if'].call(depth0, (depth1 && depth1['class']), {hash:{},inverse:self.noop,fn:self.programWithDepth(21, program21, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">";
  stack1 = (typeof depth0 === functionType ? depth0.apply(depth0) : depth0);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</button>\n      ";
  return buffer;
  }

function program32(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n      ";
  if (helper = helpers.template) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.template); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  return buffer;
  }

  buffer += "<div class=\"field-group\" data-description=\"";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.description), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.global), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-name=\"";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.hide), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.label), {hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "<span class=\"field-group-content\">\n    ";
  stack1 = (helper = helpers.equals || (depth0 && depth0.equals),options={hash:{},inverse:self.noop,fn:self.program(12, program12, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "text", options) : helperMissing.call(depth0, "equals", (depth0 && depth0.type), "text", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  stack1 = (helper = helpers.equals || (depth0 && depth0.equals),options={hash:{},inverse:self.noop,fn:self.program(15, program15, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "textarea", options) : helperMissing.call(depth0, "equals", (depth0 && depth0.type), "textarea", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  stack1 = (helper = helpers.equals || (depth0 && depth0.equals),options={hash:{},inverse:self.noop,fn:self.program(17, program17, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "radio", options) : helperMissing.call(depth0, "equals", (depth0 && depth0.type), "radio", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  stack1 = (helper = helpers.equals || (depth0 && depth0.equals),options={hash:{},inverse:self.noop,fn:self.program(23, program23, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "checkbox", options) : helperMissing.call(depth0, "equals", (depth0 && depth0.type), "checkbox", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  stack1 = (helper = helpers.equals || (depth0 && depth0.equals),options={hash:{},inverse:self.noop,fn:self.program(25, program25, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "select", options) : helperMissing.call(depth0, "equals", (depth0 && depth0.type), "select", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  stack1 = (helper = helpers.equals || (depth0 && depth0.equals),options={hash:{},inverse:self.noop,fn:self.program(29, program29, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "button", options) : helperMissing.call(depth0, "equals", (depth0 && depth0.type), "button", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  stack1 = (helper = helpers.equals || (depth0 && depth0.equals),options={hash:{},inverse:self.noop,fn:self.program(32, program32, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.type), "custom", options) : helperMissing.call(depth0, "equals", (depth0 && depth0.type), "custom", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  </span>\n</div>\n";
  return buffer;
  });
templates["eevee/form-generator"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); partials = this.merge(partials, Handlebars.partials); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n  <h2>";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</h2>\n  ";
  return buffer;
  }

function program3(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n  <p>";
  if (helper = helpers.description) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.description); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</p>\n  ";
  return buffer;
  }

function program5(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n  ";
  stack1 = self.invokePartial(partials['field-group'], 'field-group', depth0, helpers, partials, data);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  return buffer;
  }

function program7(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n  ";
  if (helper = helpers.template) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.template); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  return buffer;
  }

  buffer += "<form action=\"\" data-scope=\""
    + escapeExpression(((stack1 = (data == null || data === false ? data : data.key)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.name), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.description), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.props), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.template), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</form>\n";
  return buffer;
  });
templates["eevee/hover-mask"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, self=this, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  
  return "eve-editor-selected-mask";
  }

function program3(depth0,data) {
  
  
  return "eve-editor-hover-mask";
  }

  buffer += "<div class=\"";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.selected), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n  <div class=\"eve-editor-mask-margin-area\" style=\"top:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.margin)),stack1 == null || stack1 === false ? stack1 : stack1.top)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;left:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.margin)),stack1 == null || stack1 === false ? stack1 : stack1.left)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;width:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.margin)),stack1 == null || stack1 === false ? stack1 : stack1.width)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;height:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.margin)),stack1 == null || stack1 === false ? stack1 : stack1.height)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;\"></div>\n  <div class=\"eve-editor-mask-real-area\" style=\"top:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.real)),stack1 == null || stack1 === false ? stack1 : stack1.top)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;left:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.real)),stack1 == null || stack1 === false ? stack1 : stack1.left)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;width:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.real)),stack1 == null || stack1 === false ? stack1 : stack1.width)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;height:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.real)),stack1 == null || stack1 === false ? stack1 : stack1.height)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;\">\n    <span>";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</span>\n  </div>\n</div>\n";
  return buffer;
  });
templates["eevee/image-selector/list"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n<li>\n  ";
  stack1 = helpers.each.call(depth0, depth0, {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</li>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n  <span data-url=\"";
  if (helper = helpers.url) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.url); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" data-id=\"";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\"><img src=\"";
  if (helper = helpers.url) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.url); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" alt=\"image\"></span>\n  ";
  return buffer;
  }

  stack1 = helpers.each.call(depth0, depth0, {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });
templates["eevee/image-selector/root"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "data-category=\"";
  if (helper = helpers.category) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.category); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\"";
  return buffer;
  }

function program3(depth0,data) {
  
  
  return "&nbsp;(多选)";
  }

function program5(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n      <div class=\"image-selector-original\">\n        <span class=\"image-desc\">\n          <p>当前图片</p>\n          <p>"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.width)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px<i class=\"fa fa-fw fa-times\"></i>"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.height)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px</p>\n        </span>\n        <span class=\"image-wrap\">\n          <img src=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.original)),stack1 == null || stack1 === false ? stack1 : stack1.url)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" alt=\"当前图片\">\n        </span>\n      </div>\n      ";
  return buffer;
  }

function program7(depth0,data) {
  
  var buffer = "", stack1, helper;
  buffer += "\n      <li data-category=\"";
  if (helper = helpers.category) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.category); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" class=\"active\">商品专用</li>\n      <li>通用</li>\n      ";
  return buffer;
  }

  buffer += "<div class=\"image-selector\" ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.category), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">\n  <div class=\"image-selector-container\">\n    <div class=\"image-selector-header\">\n      <h1>选择或上传图片";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.multiple), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</h1>\n      ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.original), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n      <div class=\"image-selector-pagination\"></div>\n    </div>\n    <ul class=\"image-selector-tab\">\n      ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.category), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n    <ul class=\"image-selector-list\">\n    </ul>\n    <div class=\"image-selector-footer\">\n      <span class=\"button big image-selector-upload\">\n        <i class=\"fa fa-upload\"></i>&nbsp;上传图片\n        <input id=\"js-image-upload\" style=\"position: absolute; top: 0; right: 0; height: 100%; opacity: 0; filter: alpha(opacity=0); cursor: pointer;\" type=\"file\" name=\"file\" multiple=\"true\">\n      </span>\n      <input class=\"image-selector-url\" type=\"text\" name=\"url\" placeholder=\"或者直接输入图片地址\">\n      <div class=\"image-selector-control\">\n        <button class=\"big js-delete\"><i class=\"fa fa-trash-o\"></i>&nbsp;删除</button>\n        <button class=\"big js-ok\"><i class=\"fa fa-check\"></i>&nbsp;确认</button>\n        <button class=\"big js-clean\"><i class=\"fa fa-ban\"></i>&nbsp;清除</button>\n        <button class=\"big js-cancel\"><i class=\"fa fa-circle-o\"></i>&nbsp;取消</button>\n      </div>\n    </div>\n  </div>\n</div>\n";
  return buffer;
  });
templates["eevee/key-shortcut-tip"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"key-shortcut-tip\">\n  <div class=\"key-shortcut-container\">\n    <div class=\"key-shortcut-header\">\n      <h1>快捷键说明</h1>\n      <a href=\"#\" class=\"key-shortcut-close\">关闭</a>\n    </div>\n    <ul class=\"key-shortcut-list\">\n      <li>\n        <span class=\"keys\"><kbd>ESC</kbd></span>\n        取消选中，取消弹出框。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>DELETE</kbd></span>\n        删除选中的组件。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>ENTER</kbd></span>\n        确认弹出框。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>a</kbd></span>\n        为选中的组件添加子组件，组件将被添加在末尾。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>shift</kbd>+<kbd>a</kbd></span>\n        为选中的组件添加子组件，组件将被添加在头部。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>i</kbd></span>\n        在选中的组件后插入兄弟组件。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>shift</kbd>+<kbd>i</kbd></span>\n        在选中的组件前插入兄弟组件。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>g</kbd></span>\n        定位到选中的组件所在位置。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>p</kbd></span>\n        切换预览和编辑模式。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>o</kbd></span>\n        切换概览和正常显示。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>l</kbd></span>\n        打开/关闭页面列表面板。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>ctrl</kbd>+<kbd>s</kbd></span>\n        保存。\n      </li>\n      <li>\n        <span class=\"keys\"><kbd>?</kbd>(<kbd>shift</kbd>+<kbd>/</kbd>)</span>\n        显示此文档。\n      </li>\n    </ul>\n  </div>\n</div>\n";
  });
templates["eevee/page-config"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  
  return "新建一个页面。";
  }

function program3(depth0,data) {
  
  
  return "修改页面信息";
  }

function program5(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n      "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.page)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n      ";
  return buffer;
  }

function program7(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n      <input type=\"text\" name=\"name\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.page)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n      ";
  return buffer;
  }

function program9(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n      "
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.page)),stack1 == null || stack1 === false ? stack1 : stack1.path)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\n      ";
  return buffer;
  }

function program11(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n      <input type=\"text\" name=\"path\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.page)),stack1 == null || stack1 === false ? stack1 : stack1.path)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">\n      ";
  return buffer;
  }

  buffer += "<p>";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.newPage), {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</p>\n<form action=\"\" id=\"js-page-form\">\n  <div class=\"field-group\">\n    <span class=\"field-group-label\">名字: </span>\n    <span class=\"field-group-content\">\n      ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.inShop), {hash:{},inverse:self.program(7, program7, data),fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </span>\n    <div class=\"field-group-helper\">描述性的信息</div>\n  </div>\n  <div class=\"field-group\">\n    <span class=\"field-group-label\">路径: </span>\n    <span class=\"field-group-content\">\n      ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.inShop), {hash:{},inverse:self.program(11, program11, data),fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </span>\n    <div class=\"field-group-helper\">url 上的访问路径</div>\n  </div>\n  <div class=\"field-group\">\n    <span class=\"field-group-label\">关键字：</span>\n    <span class=\"field-group-content\">\n      <textarea name=\"keywords\">"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.page)),stack1 == null || stack1 === false ? stack1 : stack1.keywords)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</textarea>\n    </span>\n    <div class=\"field-group-helper\">SEO 关键字</div>\n  </div>\n  <div class=\"field-group\">\n    <span class=\"field-group-label\">描述：</span>\n    <span class=\"field-group-content\">\n      <textarea name=\"description\">"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.page)),stack1 == null || stack1 === false ? stack1 : stack1.description)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</textarea>\n    </span>\n    <div class=\"field-group-helper\">SEO 描述信息</div>\n  </div>\n</form>\n<div class=\"side-dialog-control\">\n  <button type=\"submit\" class=\"big\" form=\"js-page-form\"><i class=\"fa fa-check\"></i>&nbsp;确定</button>\n</div>\n";
  return buffer;
  });
templates["eevee/page-list-line"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, functionType="function", escapeExpression=this.escapeExpression, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  
  return "page-index";
  }

function program3(depth0,data) {
  
  
  return "page-current";
  }

function program5(depth0,data) {
  
  
  return "\n    <a href=\"#\" class=\"js-page-setting\"><i class=\"fa fa-fw fa-gear\"></i></a>\n    ";
  }

function program7(depth0,data) {
  
  
  return "\n    <a href=\"#\" class=\"js-page-set-index\"><i class=\"fa fa-fw fa-sign-in\"></i></a>\n    <a href=\"#\" class=\"js-page-setting\"><i class=\"fa fa-fw fa-gear\"></i></a>\n    <a href=\"#\" class=\"js-page-delete\"><i class=\"fa fa-fw fa-times\"></i></a>\n    ";
  }

  buffer += "<li class=\"";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.isIndex), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += " ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.isCurrent), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-page-id=\"";
  if (helper = helpers.id) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.id); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\" data-page-path=\"";
  if (helper = helpers.path) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.path); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n  <div class=\"name\">";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</div>\n  <div class=\"path\">路径: ";
  if (helper = helpers.path) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.path); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</div>\n  <div class=\"settings\">\n    ";
  stack1 = (helper = helpers.equals || (depth0 && depth0.equals),options={hash:{},inverse:self.program(7, program7, data),fn:self.program(5, program5, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.mode), "SHOP", options) : helperMissing.call(depth0, "equals", (depth0 && depth0.mode), "SHOP", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  </div>\n</li>\n";
  return buffer;
  });
templates["eevee/part-manager"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <br/>\n    已存在的区域：<br/>\n    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.exists), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "";
  buffer += "\n    &nbsp;&nbsp;"
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "<br/>\n    ";
  return buffer;
  }

  buffer += "<p>\n  标记可编辑区域。\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.exists), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</p>\n<form action=\"\" id=\"js-part-form\">\n  <div class=\"field-group\">\n    <span class=\"field-group-label\">key：</span>\n    <span class=\"field-group-content\">\n      <input type=\"text\" name=\"key\" value=\"";
  if (helper = helpers.key) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.key); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n    </span>\n    <div class=\"field-group-helper\">可编辑区域的 key ，整个页面惟一</div>\n  </div>\n</form>\n<div class=\"side-dialog-control\">\n  <button type=\"submit\" class=\"big\" form=\"js-part-form\"><i class=\"fa fa-check\"></i>&nbsp;确定</button>\n</div>\n";
  return buffer;
  });
templates["eevee/properties/border-config"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, self=this, helperMissing=helpers.helperMissing, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  
  return "checked";
  }

  buffer += "<p>设置边框属性。</p>\n<form action=\"\" id=\"js-property-form\">\n  <div class=\"field-group\">\n    <span class=\"field-group-label\">样式: </span>\n    <label><input type=\"radio\" name=\"style\" value=\"none\" ";
  stack1 = (helper = helpers.equals || (depth0 && depth0.equals),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.style), "none", options) : helperMissing.call(depth0, "equals", (depth0 && depth0.style), "none", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">无</label>\n    <label><input type=\"radio\" name=\"style\" value=\"solid\" ";
  stack1 = (helper = helpers.equals || (depth0 && depth0.equals),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.style), "solid", options) : helperMissing.call(depth0, "equals", (depth0 && depth0.style), "solid", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">实线</label>\n    <label><input type=\"radio\" name=\"style\" value=\"dashed\" ";
  stack1 = (helper = helpers.equals || (depth0 && depth0.equals),options={hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data},helper ? helper.call(depth0, (depth0 && depth0.style), "dashed", options) : helperMissing.call(depth0, "equals", (depth0 && depth0.style), "dashed", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += ">虚线</label>\n    \n  </div>\n  <div class=\"field-group\">\n    <span class=\"field-group-label\">宽度: </span>\n    <input type=\"text\" name=\"width\" value=\"";
  if (helper = helpers.width) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.width); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n    <div class=\"field-group-helper\">输入数字，单位像素，例如 2</div>\n  </div>\n  <div class=\"field-group\">\n    <span class=\"field-group-label\">颜色: </span>\n    <input type=\"text\" name=\"color\" value=\"";
  if (helper = helpers.color) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.color); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">\n    <div class=\"field-group-helper\">输入 6 位 16 进制颜色值，例如 FF0000</div>\n  </div>\n</form>\n<div class=\"side-dialog-control\">\n  <button type=\"submit\" class=\"big\" form=\"js-property-form\"><i class=\"fa fa-check\"></i>&nbsp;确定</button>\n</div>\n";
  return buffer;
  });
templates["eevee/selected-mask"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"eve-editor-selected-mask\" style=\"top:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.position)),stack1 == null || stack1 === false ? stack1 : stack1.top)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;left:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.position)),stack1 == null || stack1 === false ? stack1 : stack1.left)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;width:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.position)),stack1 == null || stack1 === false ? stack1 : stack1.width)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;height:"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.position)),stack1 == null || stack1 === false ? stack1 : stack1.height)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "px;\">\n  <span>";
  if (helper = helpers.name) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.name); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "</span>\n</div>\n";
  return buffer;
  });
templates["eevee/toolbar"] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, self=this;

function program1(depth0,data) {
  
  
  return "\n    <a href=\"#\" data-action=\"delete\" data-description=\"删除组件\">&nbsp;<i class=\"fa fa-trash-o\"></i>&nbsp;</a>\n  ";
  }

function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <a href=\"#\" data-action=\"add\" data-description=\"添加子组件\">&nbsp;<i class=\"fa fa-plus\"></i>&nbsp;</a>\n    ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.isCanPart), {hash:{},inverse:self.noop,fn:self.program(4, program4, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  return buffer;
  }
function program4(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n      ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.isInPart), {hash:{},inverse:self.program(7, program7, data),fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    ";
  return buffer;
  }
function program5(depth0,data) {
  
  
  return "\n        <a href=\"#\" class=\"eve-disabled\" data-action=\"togglePart\" data-description=\"已在编辑区域内\">&nbsp;<i class=\"fa fa-pencil\"></i>&nbsp;</a>\n      ";
  }

function program7(depth0,data) {
  
  
  return "\n        <a href=\"#\" data-action=\"togglePart\" data-description=\"标记或取消编辑区域\">&nbsp;<i class=\"fa fa-pencil\"></i>&nbsp;</a>\n      ";
  }

function program9(depth0,data) {
  
  
  return "\n  <a href=\"#\" data-action=\"add-before\" data-description=\"插入组件到前面\">&nbsp;<i class=\"fa fa-level-up fa-rotate-270\"></i>&nbsp;</a>\n  <a href=\"#\" data-action=\"add-after\" data-description=\"插入组件到后面\">&nbsp;<i class=\"fa fa-level-down fa-rotate-90\"></i>&nbsp;</a>\n  ";
  }

  buffer += "<div class=\"editor-config-toolbar\">\n  <a href=\"#\" data-action=\"unSelect\" data-description=\"关闭（取消选中）\">&nbsp;<i class=\"fa fa-times\"></i>&nbsp;</a>\n  <hr>\n  <a href=\"#\" data-action=\"position\" data-description=\"定位组件\">&nbsp;<i class=\"fa fa-crosshairs\">&nbsp;</i></a>\n  ";
  stack1 = helpers.unless.call(depth0, (depth0 && depth0.editable), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  stack1 = helpers.unless.call(depth0, (depth0 && depth0.isComponent), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  stack1 = helpers.unless.call(depth0, (depth0 && depth0.isRoot), {hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</div>\n";
  return buffer;
  });

})();
