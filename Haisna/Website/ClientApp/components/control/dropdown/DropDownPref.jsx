import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

import DropDown from './DropDown';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownPref extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    // 都道府県レコードを得る
    axios
      .get('/api/v1/prefectures')
      .then((res) => {
        // 都道府県レコードをDropDownコンポーネントのitemsプロパティ形式に変換
        const items = res.data.map((rec) => ({
          value: rec.prefcd,
          name: rec.prefname,
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
  tokyu: PropTypes.bool,
};

// DropDownコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(DropDown);
