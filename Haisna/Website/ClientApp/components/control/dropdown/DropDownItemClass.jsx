import React from 'react';
import PropTypes from 'prop-types';

import DropDown from './DropDown';
import itemService from '../../../services/preference/itemService';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownItemClass extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    // 検査分類レコードを得る
    itemService.getItemClassList()
      .then((data) => {
        // 検査分類レコードをDropDownコンポーネントのitemsプロパティ形式に変換
        const items = data.map((rec) => ({
          value: rec.classcd,
          name: rec.classname,
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
