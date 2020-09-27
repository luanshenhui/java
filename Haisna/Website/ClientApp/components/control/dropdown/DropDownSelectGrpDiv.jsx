import React from 'react';
import DropDown from './DropDown';
import groupService from '../../../services/preference/groupService';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownSelectGrpDiv extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    const props = Object.assign({}, this.props);
    const { grpDiv } = props;
    // propsで指定された汎用コードをキーに汎用レコードを得る
    const promise = groupService.getGrpIListGrpDiv({ grpdiv: grpDiv });
    promise.then((res) => {
      // 汎用レコードをDropDownコンポーネントのitemsプロパティ形式に変換
      const items = res.map((rec) => ({
        value: rec.grpcd,
        name: rec.grpname,
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
