import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

import DropDown from './DropDown';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownCourse extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    const { tokyu, mode } = this.props;
    // コースレコードを得る
    axios
      .get('/api/v1/courses/', { params: { mode } })
      .then((res) => {
        // コースレコードをDropDownコンポーネントのitemsプロパティ形式に変換
        const items = res.data.map((rec) => ({
          value: rec.cscd,
          name: rec.csname,
        }));

        // 東急用アイテムを追加
        if (tokyu) {
          items.unshift({
            value: 'regular',
            name: '■すべての定期健診コース',
          });
        }

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
  mode: PropTypes.number,
};

// DropDownコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(DropDown);
