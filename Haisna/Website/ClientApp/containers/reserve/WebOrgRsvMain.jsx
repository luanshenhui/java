import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { reduxForm } from 'redux-form';
import { withRouter } from 'react-router-dom';
import WebOrgRsvDetail from './WebOrgRsvDetail';
import WebOrgRsvNavi from './WebOrgRsvNavi';
import { webOrgRsvMainLoadRequest, closeWebOrgRsvMainGuide } from '../../modules/reserve/webOrgRsvModule';
import GuideBase from '../../components/common/GuideBase';

const formName = 'WebOrgRsvMain';
class WebOrgRsvMain extends React.Component {
  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextprops) {
    const { onLoad, params } = nextprops;
    const { visible } = this.props;
    if (!visible && visible !== nextprops.visible) {
      onLoad(params);
    }
  }
  render() {
    return (
      <GuideBase {...this.props} title="web団体予約情報登録" usePagination={false} >
        <div style={{ overflow: 'auto', width: '1000px' }}>
          <WebOrgRsvNavi />
          <WebOrgRsvDetail />
        </div>
      </GuideBase>
    );
  }
}

const WebOrgRsvMainForm = reduxForm({
  form: formName,
})(WebOrgRsvMain);

WebOrgRsvMain.propTypes = {
  visible: PropTypes.bool,
  onLoad: PropTypes.func.isRequired,
  params: PropTypes.shape(),
  formValues: PropTypes.shape(),
};

WebOrgRsvMain.defaultProps = {
  formValues: undefined,
  visible: false,
  params: null,
};

const mapStateToProps = (state) => ({
  // 可視状態
  visible: state.app.reserve.webOrgRsv.webOrgRsvMain.visible,
  params: state.app.reserve.webOrgRsv.webOrgRsvMain.params,
});

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 画面を初期化
    dispatch(webOrgRsvMainLoadRequest({ params }));
  },

  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeWebOrgRsvMainGuide());
  },

});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(WebOrgRsvMainForm));
