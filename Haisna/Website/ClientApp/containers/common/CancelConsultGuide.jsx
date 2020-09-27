/**
 * @file 予約キャンセルガイド
 */
import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, Field } from 'redux-form';
import styled from 'styled-components';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';

// 共通コンポーネント
import Modal from '../../components/Modal/Modal';
import Button from '../../components/control/Button';
import DropDown from '../../components/control/dropdown/DropDown';
import CheckBox from '../../components/control/CheckBox';

// 受診情報モジュール
import * as consultModules from '../../modules/reserve/consultModule';

// 表示領域の設定
const Content = styled(DialogContent)`
  height: 190px;
  width: 600px;
`;

const LineWrapper = styled.div`
  margin: 0 0 15px 0;
`;

const formName = 'cancelReserveGuide';

// 初期値
const initialValues = {
  cancelFlg: 1,
  notCancelForce: 1,
};

const mapStateToProps = (state) => ({
  initialValues,
  guideState: state.app.reserve.consult.cancelGuide,
});

const mapDispatchToProps = (dispatch) => ({
  consultActions: bindActionCreators(consultModules, dispatch),
});

// 受診キャンセルガイドメイン処理
const CancelConsultGuide = (props) => {
  const { guideState, consultActions, handleSubmit, reset } = props;

  // キャンセル理由の選択肢有無
  const hasItems = guideState.reasonItems && guideState.reasonItems.length > 0;

  // ガイドクローズ処理
  const handleClose = () => {
    consultActions.closeCancelConsultGuide();
    reset();
  };

  // キャンセル実行処理
  const handleSubmitContent = (values) => {
    const params = { rsvno: guideState.rsvno };
    const data = { cancelFlg: values.cancelFlg, force: values.notCancelForce !== 1 };
    consultActions.registerCancelConsultRequest({
      params,
      data,
      redirect: () => guideState.redirect(params),
    });
    handleClose();
  };

  // レンダリング
  return (
    <Modal
      caption="予約のキャンセル"
      open={guideState.visible}
      onClose={() => handleClose()}
    >
      <Content>
        <form onSubmit={handleSubmit((values) => handleSubmitContent(values))}>
          <LineWrapper>
            この予約情報をキャンセルします。
          </LineWrapper>
          {hasItems &&
            <LineWrapper>
              キャンセル理由：<Field component={DropDown} name="cancelFlg" items={guideState.reasonItems} />
            </LineWrapper>
          }
          {!hasItems &&
            <LineWrapper>
              キャンセル理由が登録されていません。
            </LineWrapper>
          }
          <LineWrapper>
            <Field component={CheckBox} name="notCancelForce" label="問診が入力されている場合はキャンセルを行わない" checkedValue={1} />
          </LineWrapper>
          <DialogActions>
            {hasItems &&
              <Button value="確定" type="submit" />
            }
            <Button value="キャンセル" onClick={() => handleClose()} />
          </DialogActions>
        </form>
      </Content>
    </Modal>
  );
};

// propTypesの定義
CancelConsultGuide.propTypes = {
  guideState: PropTypes.shape().isRequired,
  consultActions: PropTypes.shape().isRequired,
  reset: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
};

const CancelConsultGuideForm = reduxForm({
  form: formName,
})(CancelConsultGuide);

export default connect(mapStateToProps, mapDispatchToProps)(CancelConsultGuideForm);
