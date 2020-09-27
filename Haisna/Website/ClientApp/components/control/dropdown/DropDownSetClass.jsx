import React from 'react';
import axios from 'axios';

import DropDown from './DropDown';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownSetClass extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    // セット分類レコードを得る
    axios.get('/api/v1/setclass').then((res) => {
      // セット分類レコードをDropDownコンポーネントのitemsプロパティ形式に変換
      const items = res.data.map((rec) => ({
        value: rec.setclasscd,
        name: rec.setclassname,
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

// DropDownコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(DropDown);
