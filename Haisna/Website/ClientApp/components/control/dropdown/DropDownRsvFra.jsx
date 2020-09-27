import React from 'react';
import scheduleService from '../../../services/preference/scheduleService';

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
    // 予約枠の一覧ドを得る
    const promise = scheduleService.getRsvFraList();
    promise.then((data) => {
      const items = data.map((rec) => ({
        value: rec.rsvfracd,
        name: rec.rsvfraname,
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
