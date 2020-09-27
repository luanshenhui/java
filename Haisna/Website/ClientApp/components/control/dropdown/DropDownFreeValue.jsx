import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

import DropDown from './DropDown';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownFreeValue extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    const { freecd, namefield } = this.props;
    // propsで指定された汎用コードをキーに汎用レコードを得る
    axios.get(
      '/api/v1/frees/',
      {
        params: {
          mode: '1',
          freecd: freecd.toUpperCase(),
        },
      },
    ).then((res) => {
      // 汎用レコードをDropDownコンポーネントのitemsプロパティ形式に変換
      const items = res.data.map((rec) => ({
        value: rec.freecd,
        name: rec[namefield || 'freefield1'],
      }));
      // stateに格納することでrenderメソッドが呼び出される
      this.setState({ items });
    });
  }
  // render処理
  render() {
    return (
      <WrappedComponent {...this.props} items={this.state.items} />
    );
  }
};

// propTypesの定義
enhance.propTypes = {
  freecd: PropTypes.string.isRequired,
  namefield: PropTypes.string,
}
// defaultPropsの定義
enhance.defaultProps = {
  namefield: null,
}

// DropDownコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(DropDown);
