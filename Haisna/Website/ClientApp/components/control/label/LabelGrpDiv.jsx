import React from 'react';
import PropTypes from 'prop-types';
import Label from '../../control/Label';
import groupService from '../../../services/preference/groupService';

// Labelコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class LabelGrpDiv extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = {
      grpname: '',
    };
  }

  // Labelコースの初期処理
  componentDidMount() {
    const props = Object.assign({}, this.props);
    const { grpDiv, grpcd } = props;
    const promise = groupService.getGrpIListGrpDiv({ grpdiv: grpDiv });
    promise.then((data) => {
      for (let i = 0; i < data.length; i += 1) {
        if (data[i].grpcd === grpcd) {
          const { grpname } = data[i];
          this.setState({ grpname });
          break;
        }
      }
    });
  }

  // render処理
  render() {
    const props = Object.assign({}, this.props);
    const { style } = props;
    return (
      <WrappedComponent {...this.props} >
        {(<span style={style}>{this.state.grpname}</span>)}
      </WrappedComponent>
    );
  }
};

// propTypesの定義
enhance.propTypes = {
  cscd: PropTypes.string.isRequired,
  CtrCsName: PropTypes.string,
  mark: PropTypes.bool,
  style: PropTypes.shape(),
};

// Labelコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(Label);

