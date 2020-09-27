import React from 'react';
import PropTypes from 'prop-types';

import Label from '../../control/Label';
import freeService from '../../../services/preference/freeService';

// Labelコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class ToMapWebOptName extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = {
      webOptName: '',
    };
  }

  // Labelコースの初期処理
  componentDidMount() {
    const props = Object.assign({}, this.props);
    const { csloptions } = props;
    let index;
    let webOptName;
    let blnMammoEcho;
    const arrWebOptCd = [];

    if (csloptions && csloptions != null) {
      const arrWkWebOptCd = csloptions.split(',');

      // 全要素のトリミング、かつ乳房X線、乳房超音波同時受診であるかを判定
      for (let i = 0; i < arrWkWebOptCd.length; i += 1) {
        if (arrWkWebOptCd[i] === 'P-XandE') {
          blnMammoEcho = true;
        }
      }

      // 空要素の除去、及び乳房X線、乳房超音波同時受診時の特殊処理
      for (let i = 0; i < arrWkWebOptCd.length; i += 1) {
        let flg = false;
        // 乳房X線、乳房超音波同時受診時は、乳房X線及び乳房超音波単独のオプションコードをスキップ
        if (blnMammoEcho && (arrWkWebOptCd[i] === 'P06' || arrWkWebOptCd[i] === 'P07')) {
          flg = true;
        }

        // 上記除外条件を満たさない場合は要素を追加
        if (!flg) {
          arrWebOptCd.push(arrWkWebOptCd[i]);
        }
      }
      webOptName = [arrWkWebOptCd.length];
      const params = {};
      params.mode = 0;
      params.freeclasscd = 'WOP';
      // 団体情報取得を得る
      const promise = freeService.getFreeByClassCd(params);
      promise.then((data) => {
        if (data !== null) {
          // 変換情報を検索し、オプションコードが一致する変換情報のインデックスを求める
          for (let i = 0; i < arrWebOptCd.length; i += 1) {
            index = -1;
            for (let j = 0; j < data.length; j += 1) {
              if (data[j].freefield1 === arrWebOptCd[i]) {
                index = j;
                break;
              }
            }

            // 検索成功時はオプション名とオプションコードの組となる文字列を、さもなくばオプションコードのみを編集
            if (index >= 0) {
              webOptName[i] = `${data[index].freefield2}(${arrWebOptCd[i]})`;
            } else {
              webOptName[i] = arrWebOptCd[i];
            }
          }

          // stateに格納することでrenderメソッドが呼び出される
          this.setState({ webOptName });
        }
      });
    }
  }

  // render処理
  render() {
    return (
      <WrappedComponent {...this.props} >
        {this.state && this.state.webOptName !== '' && this.state.webOptName.map((rec) => (
          <div key={rec}>
            {rec}<br />
          </div>
        ))}
      </WrappedComponent>
    );
  }
};

// propTypesの定義
enhance.propTypes = {
  csloptions: PropTypes.string.isRequired,
};

// Labelコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(Label);
