import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

import DropDown from './DropDown';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownReportStyle extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    const { vieworder } = this.props;

    // 出力様式レコードを得る
    axios.get(
      '/api/v1/reports/style', {
        params: {
          vieworder: (vieworder ? '1' : '0'),
        },
      },
    ).then((res) => {
      // 出力様式レコードをDropDownコンポーネントのitemsプロパティ形式に変換
      const items = res.data.data.map((rec) => ({
        value: rec.reportcd,
        name: rec.reportname,
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

// propTypesを定義
enhance.propTypes = {
  // 表示順に従い出力するかどうかのフラグ
  vieworder: PropTypes.bool,
};

// DropDownコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(DropDown);
