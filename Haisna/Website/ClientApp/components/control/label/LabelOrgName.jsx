import React from 'react';
import PropTypes from 'prop-types';

import Label from '../../control/Label';
import organizationService from '../../../services/preference/organizationService';

// Labelコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class LabelOrgName extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = {
      orgName: '',
    };
  }

  // Labelコースの初期処理
  componentDidMount() {
    const props = Object.assign({}, this.props);
    const { orgcd1, orgcd2 } = props;

    if ((orgcd1 && orgcd1 != null) && (orgcd2 && orgcd2 != null)) {
      // 団体情報取得を得る
      const promise = organizationService.getOrg({ orgcd1, orgcd2 });
      promise.then((data) => {
        if (data !== null) {
          // 団体情報取得をLabelコンポーネントのOrgNameプロパティ形式に変換
          const orgName = data.org.orgname;

          // stateに格納することでrenderメソッドが呼び出される
          this.setState({ orgName });
        }
      });
    }
  }

  // render処理
  render() {
    return (
      <WrappedComponent {...this.props} >{this.state.orgName}</WrappedComponent>
    );
  }
};

// propTypesの定義
enhance.propTypes = {
  orgCd1: PropTypes.string.isRequired,
  orgCd2: PropTypes.string.isRequired,
};

// Labelコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(Label);
