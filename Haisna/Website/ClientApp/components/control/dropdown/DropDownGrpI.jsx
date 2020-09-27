import React from 'react';
// import axios from 'axios';

import DropDown from './DropDown';
import groupService from '../../../services/preference/groupService';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownGrpI extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    // 検査結果グループ一覧の取得
    groupService.getGroupListByDivision({ grpDiv: 2 })
      .then((data) => {
        const items = data.map((rec) => ({
          value: rec.grpcd,
          name: rec.grpname,
        }));
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
