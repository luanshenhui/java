import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import Label from '../../control/Label';
import courseService from '../../../services/preference/courseService';

const CtrCsName = styled.span`
  color: #999999;
`;

// Labelコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class LabelCourse extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = {
      csName: '',
      webColor: '',
    };
  }

  // Labelコースの初期処理
  componentDidMount() {
    const props = Object.assign({}, this.props);
    const { cscd } = props;
    if (cscd && cscd.length > 0) {
      // コースレコードを得る
      const promise = courseService.getCourse({ cscd });
      promise.then((data) => {
        if (data !== null) {
          // コースレコードをLabelコンポーネントのcsNameプロパティ形式に変換
          const csName = data.csname;
          const webColor = data.webcolor;

          // stateに格納することでrenderメソッドが呼び出される
          this.setState({ csName, webColor });
        }
      });
    }
  }

  // render処理
  render() {
    const props = Object.assign({}, this.props);
    const { ctrCsName, mark, style } = props;
    return (
      <WrappedComponent {...this.props} >
        {(mark ? <span style={{ color: `#${this.state.webColor}` }}>■</span> : '')}
        {(<span style={style}>{this.state.csName}</span>)}
        {(ctrCsName && ctrCsName.length > 0 ? <CtrCsName>({ctrCsName})</CtrCsName> : '')}
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
