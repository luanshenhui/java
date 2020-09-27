import React from 'react';

import orgGrpService from '../../../services/preference/orgGrpService';

import DropDown from './DropDown';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownOrgGrpP extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    orgGrpService.getOrgGrp_PList().then((res) => {
      // 団体グループレコードをDropDownコンポーネントのitemsプロパティ形式に変換
      const items = res.map((rec) => ({
        value: rec.orggrpcd,
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
