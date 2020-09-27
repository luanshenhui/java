/**
 * @file お連れ様更新ガイド
 */
import React from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { reduxForm, Field, getFormValues, FieldArray } from 'redux-form';
import moment from 'moment';

import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';

// 共通コンポーネント
import Modal from '../../components/Modal/Modal';
import Button from '../../components/control/Button';
import MessageBanner from '../../components/MessageBanner';
import GenderName from '../../components/common/GenderName';
import Table from '../../components/Table';
import DropDown from '../../components/control/dropdown/DropDown';
import ConsultationListGuide from '../../containers/common/ConsultationListGuide';

import Friends from '../../components/common/EditFriendsGuide/Friends';
import * as consultModule from '../../modules/reserve/consultModule';

// 最大同時受診者数
const SAMEGRP_SELMAX = 99;

// 表示領域の設定
const Content = styled(DialogContent)`
  height: 600px;
  width: 1000px;
`;

// レイアウト
const PersonGroup = styled.div`
  display: table;
`;
const PerIdField = styled.div`
  display: table-cell;
`;
const PersonField = styled.div`
`;

const form = 'editFriendsGuide';

const mapStateToProps = (state) => {
  const formValues = getFormValues(form)(state);
  return {
    formValues,
    guideState: state.app.reserve.consult.editFriendsGuide,
    initialValues: state.app.reserve.consult.editFriendsGuide.data,
  };
};

const mapDispatchToProps = (dispatch) => ({
  consultActions: bindActionCreators(consultModule, dispatch),
});

const EditFriendsGuide = (props) => {
  const { guideState, consultActions, formValues, handleSubmit } = props;
  const { consult, person, friends, lines } = guideState.data;

  // クローズ処理
  const handleClose = () => {
    consultActions.closeEditFriendsGuide();
  };

  // 削除クリック時処理
  const handleClickDelete = () => {
    if (person.compperid) {
      // eslint-disable-next-line no-alert
      return alert('同伴者がいるため、このお連れ様情報は削除できません');
    }

    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('このお連れ様情報をすべて削除します。よろしいですか？')) {
      return false;
    }

    // 削除処理
    return consultActions.deleteEditFriendsGuideRequest({
      csldate: friends[0].csldate,
      seq: friends[0].seq,
    });
  };

  // 保存実行時処理
  const handleSubmitContent = (values) => {
    const data = values.filter((rec) => rec && rec.rsvno);

    // 各同時面接受診者数をカウント
    const countSameGrp1 = data.filter((rec) => rec.samegrp1).length;
    const countSameGrp2 = data.filter((rec) => rec.samegrp2).length;
    const countSameGrp3 = data.filter((rec) => rec.samegrp3).length;

    if (countSameGrp1 === 1 || countSameGrp2 === 1 || countSameGrp3 === 1) {
      // eslint-disable-next-line no-alert
      return alert('面接同時受診を選択するには2人以上選択してください');
    }

    if (countSameGrp1 > SAMEGRP_SELMAX || countSameGrp2 > SAMEGRP_SELMAX || countSameGrp3 > SAMEGRP_SELMAX) {
      // eslint-disable-next-line no-alert
      return alert(`面接同時受診は最大${SAMEGRP_SELMAX}人までしか選択できません`);
    }

    // 同伴者1対1チェック
    for (let i = 0; i < data.length; i += 1) {
      if (!data[i].compperid) {
        continue;
      }
      // お連れ様内に同伴者がいない場合はチェック対象外
      if (data[i].compperid === data[i].compperidorg) {
        continue;
      }
      let count = 0;
      for (let j = 0; j < data.length; j += 1) {
        if (i === j) {
          continue;
        }
        if (data[i].compperid === data[j].perid &&
            data[i].perid === data[j].compperid) {
          count += 1;
        }
      }
      if (count !== 1) {
        // eslint-disable-next-line no-alert
        return alert(`同伴者設定は必ず１対１になるようにしてください count=${count}`);
      }
    }
    return consultActions.registerEditFriendsGuideRequest(values);
  };

  // 表示行数変更処理
  const handleClickChangeLines = () => {
    consultActions.changeLinesEditFriendsGuide(parseInt(formValues.lines, 10));
  };

  // 受診者ガイドボタンクリック時処理
  const handleClickConsultGuideButton = (onSelected) => {
    const conditions = { csldate: consult.csldate };
    consultActions.openConsultationListGuide({ conditions, onSelected, perid: consult.perid });
  };

  return (
    <Modal
      caption="お連れ様～同伴者情報更新"
      open={guideState.visible}
      onClose={() => handleClose()}
    >
      <Content>
        <MessageBanner messages={guideState.messages} />
        <div>
          受診日：{consult.csldate && moment(consult.csldate).format('YYYY/MM/DD')}　受診コース：{consult.csname}　予約番号：{consult.rsvno}
        </div>
        <PersonGroup>
          <PerIdField>
            {consult.perid}
          </PerIdField>
          <PersonField>
            {consult.lastname}　{consult.firstname}({consult.lastkname}　{consult.firstkname})
          </PersonField>
          <PersonField>
            {consult.birth && moment(consult.birth).format('YYYY/MM/DD')}生　{consult.age}歳　{consult.gender && <GenderName code={consult.gender} />}
          </PersonField>
        </PersonGroup>
        <form onSubmit={handleSubmit((values) => handleSubmitContent(values.friends))}>
          <DialogActions>
            <Button value="削除" onClick={() => handleClickDelete()} />
            <Button value="保存" type="submit" />
          </DialogActions>
          <Table>
            <thead>
              <tr>
                <th />
                <th>個人ＩＤ</th>
                <th>氏名</th>
                <th>予約番号</th>
                <th>受診団体</th>
                <th>受診コース</th>
                <th>予約群</th>
                <th colSpan="3">面接を同時受診</th>
                <th>同伴者</th>
              </tr>
            </thead>
            <FieldArray
              {...props}
              component={Friends}
              name="friends"
              lines={lines}
              openGuide={(onSelected) => handleClickConsultGuideButton(onSelected)}
              compPerId={person.compperid}
            />
          </Table>
        </form>
        <Field component={DropDown} name="lines" items={guideState.lineItems} />
        <Button value="表示" onClick={() => handleClickChangeLines()} />
      </Content>
      <ConsultationListGuide />
    </Modal>
  );
};

// propTypes定義
EditFriendsGuide.propTypes = {
  formValues: PropTypes.shape(),
  handleSubmit: PropTypes.func.isRequired,
  guideState: PropTypes.shape().isRequired,
  consultActions: PropTypes.shape().isRequired,
};

// defaultProps定義
EditFriendsGuide.defaultProps = {
  formValues: {},
};

const EditFriendsGuideForm = reduxForm({
  form,
  enableReinitialize: true,
})(EditFriendsGuide);

export default connect(mapStateToProps, mapDispatchToProps)(EditFriendsGuideForm);
