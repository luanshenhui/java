import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import GuideBase from '../../components/common/GuideBase';
import SectionBar from '../../components/SectionBar';

import InterviewHeader from '../../containers/common/InterviewHeaderForm';
import MenFoodCommentGuide from './MenFoodCommentGuide';
import Shokusyukan201210Body from './Shokusyukan201210Body';
import { getShokusyukanListRequest, closeShokusyukan201210Guide } from '../../modules/judgement/interviewModule';


class Shokusyukan201210 extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.winmode = match.params.winmode;
    this.rsvno = match.params.rsvno;
    this.grpcd = match.params.grpno;
    this.cscd = match.params.cscd;
  }

  componentDidMount() {
    const { onLoad, match } = this.props;
    if (this.winmode === '0') {
      onLoad(match.params);
    }
    this.draw();
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { visible, onLoad } = this.props;
    if (!visible && nextProps.visible !== visible) {
      if (this.winmode === '1') {
        const { match } = nextProps;
        // onLoadアクションの引数として渡す
        onLoad(match.params);
      }
    }
  }
  componentDidUpdate() {
    this.draw();
  }

  draw() {
    const { data } = this.props;
    // 円周率
    const PI = 3.14159265358979;
    // 線の太さのデフォルト値
    const defaultlinewidth = 1;

    const config = {
      outertriangle: {
        // center: {x: 200, y: 200}
        // 中心のXY座標
        // distance: 150
        // 中心からの距離
        // 中心のXY座標
        center: { x: 150, y: 150 },
        // 中心からの距離
        distance: 120,
        // 線色
        outlinecolor: '#1F477A',
        // 線の太さ
        outlinewidth: 3,

      },
      resulttriangle: {
        // 線色
        resultlinecolor: '#FF0000',
        // 線の太さ
        resultlinewidth: 3,
      },
      howdoyoueat: {
        // キャプション及び頂点からの相対座標
        caption: { value: '食べ方', x: 8, y: -20 },
        // 頂点値及び頂点からの相対座標
        vertex: { value: 0, x: -4, y: -20 },
        // 中央値及び頂点からの相対座標
        center: { value: -8, x: -20, y: -22 },
      },
      eatinghabits: {
        // キャプション及び頂点からの相対座標
        caption: { value: '食習慣', x: -30, y: 6 },
        // 頂点値及び頂点からの相対座標
        vertex: { value: 0, x: -13, y: -8 },
        // 中央値及び頂点からの相対座標
        center: { value: -11, x: -19, y: 5 },
      },
      favoritefoods: {
        // キャプション及び頂点からの相対座標
        caption: { value: '食事内容', x: -20, y: 6 },
        // 頂点値及び頂点からの相対座標
        vertex: { value: 0, x: 4, y: -8 },
        // 中央値及び頂点からの相対座標
        center: { value: -16, x: 11, y: -8 },
      },
      // フォント
      font: "14px 'ＭＳ Ｐゴシック'",
      // 三角形中央から各プロット項目の最小値位置までの距離
      distance_of_minvalue: 10,
    };
    // コンテキストの取得
    const canvas = document.getElementsByTagName('canvas');
    if (canvas[0]) {
      let ctx = canvas[0].getContext('2d');
      if (canvas[1]) {
        ctx = canvas[1].getContext('2d');
      }
      // キャンバスの初期化
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      // 食べ方（上の頂点）の座標計算
      const vertex1X = config.outertriangle.center.x;
      const vertex1Y = config.outertriangle.center.y - config.outertriangle.distance;

      // 食習慣（左下の頂点）の座標計算
      const vertex2X = config.outertriangle.center.x - Math.round(config.outertriangle.distance * Math.cos(PI / 6));
      const vertex2Y = config.outertriangle.center.y + Math.round(config.outertriangle.distance * Math.sin(PI / 6));

      // 食事内容（右下の頂点）の座標計算
      const vertex3X = config.outertriangle.center.x + Math.round(config.outertriangle.distance * Math.cos(PI / 6));
      const vertex3Y = vertex2Y;

      // 正三角形の描画
      ctx.beginPath();
      ctx.strokeStyle = config.outertriangle.outlinecolor;
      ctx.lineWidth = config.outertriangle.outlinewidth;
      ctx.moveTo(vertex1X, vertex1Y);
      ctx.lineTo(vertex2X, vertex2Y);
      ctx.lineTo(vertex3X, vertex3Y);
      ctx.closePath();
      ctx.stroke();

      ctx.lineWidth = defaultlinewidth;

      // 中心から頂点への直線描画
      ctx.beginPath();
      ctx.moveTo(config.outertriangle.center.x, config.outertriangle.center.y);
      ctx.lineTo(vertex1X, vertex1Y);
      ctx.stroke();
      ctx.beginPath();
      ctx.moveTo(config.outertriangle.center.x, config.outertriangle.center.y);
      ctx.lineTo(vertex2X, vertex2Y);
      ctx.stroke();
      ctx.beginPath();
      ctx.moveTo(config.outertriangle.center.x, config.outertriangle.center.y);
      ctx.lineTo(vertex3X, vertex3Y);
      ctx.stroke();

      ctx.font = config.font;
      ctx.textBaseline = 'top';

      // 頂点のキャプション値を描画
      ctx.fillText(config.howdoyoueat.caption.value, vertex1X + config.howdoyoueat.caption.x, vertex1Y + config.howdoyoueat.caption.y);
      ctx.fillText(config.eatinghabits.caption.value, vertex2X + config.eatinghabits.caption.x, vertex2Y + config.eatinghabits.caption.y);
      ctx.fillText(config.favoritefoods.caption.value, vertex3X + config.favoritefoods.caption.x, vertex3Y + config.favoritefoods.caption.y);

      let way = null;
      let diet = null;
      let contents = null;
      for (let i = 0; i < data.length; i += 1) {
        if (`${data[i].itemcd}-${data[i].suffix}` === '61610-01') {
          way = data[i].result;
        }
        if (`${data[i].itemcd}-${data[i].suffix}` === '61610-02') {
          diet = data[i].result;
        }
        if (`${data[i].itemcd}-${data[i].suffix}` === '61610-03') {
          contents = data[i].result;
        }
      }

      if ((way !== null) && (diet !== null) && (contents !== null)) {
        let result;
        let rate;

        // 食べ方検査結果の相対座標変換

        // 数値変換
        result = parseInt(way, 10);

        // 最大、最小を超えないための補正
        if (result > config.howdoyoueat.vertex.value) {
          result = config.howdoyoueat.vertex.value;
        } else if (result < config.howdoyoueat.center.value) {
          result = config.howdoyoueat.center.value;
        }

        // X座標＝中央のX座標
        const result1X = config.outertriangle.center.x;

        // 三角形中央から最小値位置までの距離分ずらした値を最小値のY座標とする
        let result1Y = config.outertriangle.center.y - config.distance_of_minvalue;

        // 値が最小値でない場合はY座標を変換
        if (result > config.howdoyoueat.center.value) {
          rate = (result - config.howdoyoueat.center.value) / (config.howdoyoueat.vertex.value - config.howdoyoueat.center.value);
          result1Y += Math.round((vertex1Y - result1Y) * rate);
        }

        // 食習慣検査結果の相対座標変換

        // 数値変換
        result = parseInt(diet, 10);

        // 最大、最小を超えないための補正
        if (result > config.eatinghabits.vertex.value) {
          result = config.eatinghabits.vertex.value;
        } else if (result < config.eatinghabits.center.value) {
          result = config.eatinghabits.center.value;
        }

        // 三角形中央から最小値位置までの距離分ずらした値を最小値の座標とする
        let result2X = config.outertriangle.center.x - Math.round(config.distance_of_minvalue * Math.cos(PI / 6));
        let result2Y = config.outertriangle.center.y + Math.round(config.distance_of_minvalue * Math.sin(PI / 6));

        // 値が最小値でない場合は座標を変換
        if (result > config.eatinghabits.center.value) {
          rate = (result - config.eatinghabits.center.value) / (config.eatinghabits.vertex.value - config.eatinghabits.center.value);
          result2X += Math.round((vertex2X - result2X) * rate);
          result2Y += Math.round((vertex2Y - result2Y) * rate);
        }

        // 食事内容検査結果の相対座標変換

        // 数値変換
        result = parseInt(contents, 10);

        // 最大、最小を超えないための補正
        if (result > config.favoritefoods.vertex.value) {
          result = config.favoritefoods.vertex.value;
        } else if (result < config.favoritefoods.center.value) {
          result = config.favoritefoods.center.value;
        }

        // 三角形中央から最小値位置までの距離分ずらした値を最小値の座標とする
        let result3X = config.outertriangle.center.x + Math.round(config.distance_of_minvalue * Math.cos(PI / 6));
        let result3Y = config.outertriangle.center.y + Math.round(config.distance_of_minvalue * Math.sin(PI / 6));

        // 値が最小値でない場合は座標を変換
        if (result > config.favoritefoods.center.value) {
          rate = (result - config.favoritefoods.center.value) / (config.favoritefoods.vertex.value - config.favoritefoods.center.value);
          result3X += Math.round((vertex3X - result3X) * rate);
          result3Y += Math.round((vertex3Y - result3Y) * rate);
        }

        // 三角形の描画
        ctx.beginPath();
        ctx.strokeStyle = config.resulttriangle.resultlinecolor;
        ctx.lineWidth = config.resulttriangle.resultlinewidth;
        ctx.moveTo(result1X, result1Y);
        ctx.lineTo(result2X, result2Y);
        ctx.lineTo(result3X, result3Y);
        ctx.closePath();
        ctx.stroke();

        ctx.lineWidth = defaultlinewidth;
      }
    }
  }

  render() {
    const { match } = this.props;
    const { params } = match;
    return (
      <div>
        {params.winmode === '1' && (
          <GuideBase {...this.props} title="食習慣問診" usePagination={false}>
            <InterviewHeader rsvno={this.rsvno} reqwin={0} />
            <SectionBar title="食習慣問診" />
            <Shokusyukan201210Body {...this.props} />
          </GuideBase>
        )}
        {params.winmode === '0' && (
          <div>
            <SectionBar title="食習慣問診" />
            <Shokusyukan201210Body {...this.props} />
          </div>
        )}
        <MenFoodCommentGuide />
      </div>
    );
  }
}
// propTypesの定義
Shokusyukan201210.propTypes = {
  onLoad: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

const mapStateToProps = (state) => ({
  visible: state.app.judgement.interview.getShokusyukanList.visible,
  data: state.app.judgement.interview.getShokusyukanList.data,
});
const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 画面を初期化
    const csgrp = params.cscd;
    dispatch(getShokusyukanListRequest({ ...params, hiscount: 1, grpcd: 'X0221', lastdspmode: 1, csgrp, getseqmode: 0, selectMode: 0, allDataMode: 1, dispMode: 6 }));
  },
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeShokusyukan201210Guide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Shokusyukan201210);
