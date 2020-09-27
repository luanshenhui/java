/**
 * @file 受付ガイド
 */
import React from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { reduxForm, Field } from 'redux-form';
import styled from 'styled-components';

import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';

// 共通コンポーネント
import Modal from '../../components/Modal/Modal';
import Button from '../../components/control/Button';
import Checkbox from '../../components/control/CheckBox';
import MessageBanner from '../../components/MessageBanner';
import PersonalInformation from '../../components/common/PersonalInformation';

import * as consultModules from '../../modules/reserve/consultModule';

// 表示領域の設定
const Content = styled(DialogContent)`
  height: 290px;
  width: 600px;
`;

// レイアウト
const Section = styled.div`
  margin-top: 10px;
`;
const Line = styled.div`
  margin-top: 10px;
`;

const formName = 'cancelReceptionGuide';

const mapStateToProps = (state) => ({
  guideState: state.app.reserve.consult.cancelReceptionGuide,
});

const mapDispatchToProps = (dispatch) => ({
  consultActions: bindActionCreators(consultModules, dispatch),
});

// 表示処理
const CancelReceptionGuide = (props) => {
  const { guideState, consultActions, handleSubmit, reset } = props;

  // ガイドを閉じる処理
  const handleClose = () => {
    // 画面を閉じる
    consultActions.closeCancelReceptionGuide();
    // redux-formのstateを初期化
    reset();
  };

  // submit時の処理
  const handleSubmitContent = (values) => {
    const { rsvno, csldate } = guideState.data;
    const data = { rsvno, csldate, force: values.forceFlg === 1 };
    // 受付取り消し処理実行
    consultActions.executeCancelReceptionGuideRequest({
      data,
      callback: (messages) => {
        // 受付取り消しコールバック
        guideState.onSelected({ messages });
        // 受付キャンセルガイドを閉じる
        handleClose();
      },
    });
  };

  return (
    <Modal
      caption="受付の取り消し"
      open={guideState.visible}
      onClose={() => handleClose()}
    >
      <Content>
        <MessageBanner messages={guideState.messages} />
        <form onSubmit={handleSubmit((values) => handleSubmitContent(values))}>
          <Section>
            {guideState.data.csldate}　{guideState.data.csname}
          </Section>
          <PersonalInformation {...guideState.data} />
          <Section>
            この受診者の受付を取り消します。
          </Section>
          <Line>
            <Field component={Checkbox} name="forceFlg" label="結果が入力されている場合も強制的に受付を取り消す" checkedValue={1} />
          </Line>
          <DialogActions>
            <Button
              value="確定"
              type="submit"
            />
            <Button
              value="キャンセル"
              onClick={() => handleClose()}
            />
          </DialogActions>
        </form>
      </Content>
    </Modal>
  );
};

CancelReceptionGuide.propTypes = {
  guideState: PropTypes.shape().isRequired,
  consultActions: PropTypes.shape().isRequired,
  reset: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
};

const CancelReceptionGuideForm = reduxForm({
  form: formName,
})(CancelReceptionGuide);

export default connect(mapStateToProps, mapDispatchToProps)(CancelReceptionGuideForm);
