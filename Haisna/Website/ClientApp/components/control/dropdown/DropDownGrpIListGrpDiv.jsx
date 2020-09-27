import React from 'react';
import PropTypes from 'prop-types';
import DropDown from './DropDown';
import groupService from '../../../services/preference/groupService';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownGrpIListGrpDiv extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    const params = {};
    params.grpdiv = 2;
    // 入力用検査項目セットをもつコースのみを取得
    const promise = groupService.getGrpIListGrpDiv(params);
    promise.then((res) => {
      if (res !== null) {
        // 入力用検査項目セットをDropDownコンポーネントのitemsプロパティ形式に変換
        const items = res.map((rec) => ({
          value: rec.grpcd,
          name: rec.grpname,
        }));
        // stateに格納することでrenderメソッドが呼び出される
        this.setState({ items });
      }
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
  obtainPubNoteDiv: PropTypes.func,
};

// DropDownコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(DropDown);
