import React from 'react';
import PropTypes from 'prop-types';
import DropDown from './DropDown';
import pubNoteService from '../../../services/preference/pubNoteService';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownPubNoteDivCd extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    const props = Object.assign({}, this.props);
    const { obtainPubNoteDiv } = props;
    // コース受診予約群をもつコースのみを取得
    const promise = pubNoteService.getPubNoteDivList();
    promise.then((res) => {
      if (res !== null) {
        // コース受診予約群をDropDownコンポーネントのitemsプロパティ形式に変換
        const items = res.map((rec) => ({
          value: rec.pubnotedivcd,
          name: rec.pubnotedivname,
        }));

        if (obtainPubNoteDiv) {
          obtainPubNoteDiv(res);
        }
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
