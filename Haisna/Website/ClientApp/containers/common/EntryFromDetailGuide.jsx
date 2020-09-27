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
import Radio from '../../components/control/Radio';
import TextBox from '../../components/control/TextBox';
import MessageBanner from '../../components/MessageBanner';
import PersonalInformation from '../../components/common/PersonalInformation';

import * as consultModules from '../../modules/reserve/consultModule';

// 表示領域の設定
const Content = styled(DialogContent)`
  height: 320px;
  width: 600px;
`;

// レイアウト
const Section = styled.div`
  margin-top: 10px;
`;
const DayIdMode = styled.div`
  margin-top: 10px;
  padding-left: 1em;
`;
const DayIdDetail = styled.div`
  padding-left: 2em;
`;
const DayIdField = styled(Field)`
  width: 4em;
  margin-left: 10px;
`;

const formName = 'entryFromDetailGuide';

// 初期値
const initialValues = {
  dayId: null,
  useEmptyId: null,
  dayIdMode: 0,
};

const mapStateToProps = (state) => ({
  initialValues,
  guideState: state.app.reserve.consult.entryFromDetailGuide,
});

const mapDispatchToProps = (dispatch) => ({
  consultActions: bindActionCreators(consultModules, dispatch),
});

// 当日IDのモードを指定
const getMode = ({ dayIdMode, useEmptyId }) => {
  if (dayIdMode !== 0) {
    return 3;
  }
  return useEmptyId ? 2 : 1;
};

// 表示処理
const EntryFromDetailGuide = (props) => {
  const { guideState, consultActions, handleSubmit, reset } = props;

  // ガイドを閉じる処理
  const handleClose = () => {
    // 画面を閉じる
    consultActions.closeEntryFromDetailGuide();
    // redux-formのstateを初期化
    reset();
  };

  // submit時の処理
  const handleSubmitContent = (values) => {
    // 受付時当日ID登録方法設定
    const data = {
      mode: getMode(values),
      dayid: values.dayIdMode === 1 ? values.dayId : 0,
    };

    // 当日IDバリデーション
    consultActions.validateConsultEntryFromDetailRequest({
      data,
      callback: () => {
        // 当日IDのモードと当日IDをコールバックに戻す
        guideState.onSelected(data);
        // ガイドを閉じる
        handleClose();
      },
    });
  };

  return (
    <Modal
      caption="受付"
      open={guideState.visible}
      onClose={() => handleClose()}
    >
      <Content>
        <MessageBanner messages={guideState.messages} />
        <form onSubmit={handleSubmit((values) => handleSubmitContent(values))}>
          <PersonalInformation {...guideState} />
          <Section>
            受診コース：{guideState.csname}
          </Section>
          <Section>
            ●当日ＩＤの割り当て方法を指定して下さい。
          </Section>
          <DayIdMode>
            <Field component={Radio} name="dayIdMode" label="当日ＩＤを自動で発番する" checkedValue={0} />
          </DayIdMode>
          <DayIdDetail>
            <Field component={Checkbox} name="useEmptyId" label="空き番号が存在する場合、その番号で割り当てを行う" checkedValue={1} />
          </DayIdDetail>
          <DayIdMode>
            <Field component={Radio} name="dayIdMode" label="当日ＩＤを直接指定する" checkedValue={1} />
          </DayIdMode>
          <DayIdDetail>
            当日ID
            <DayIdField component={TextBox} name="dayId" />
          </DayIdDetail>
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

EntryFromDetailGuide.propTypes = {
  guideState: PropTypes.shape().isRequired,
  consultActions: PropTypes.shape().isRequired,
  reset: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
};

const EntryFromDetailGuideForm = reduxForm({
  form: formName,
})(EntryFromDetailGuide);

export default connect(mapStateToProps, mapDispatchToProps)(EntryFromDetailGuideForm);
