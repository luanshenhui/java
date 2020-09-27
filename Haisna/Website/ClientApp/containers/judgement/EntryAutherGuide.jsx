import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';
import MessageBanner from '../../components/MessageBanner';
import Button from '../../components/control/Button';
import GuideBase from '../../components/common/GuideBase';
import Radio from '../../components/control/Radio';
import { getEntryAutherSelectRadio, registerEntryAutherRequest, closeEntryAutherGuide } from '../../modules/result/resultModule';

const formName = 'EntryAutherGuide';
const Wrapper = styled.div`
   width: 87px;
   background-color: #cccccc;
   float: left;
`;
const WrapperWrap = styled.div`
   float: left;
`;

// 担当者情報
const JudDocDetail = ({ data, flagMen, flagJud, flagKan, flagEif, flagShi, flagNai, checkValue }) => {
  const reuserName = [];
  if (data && data.menflg === 1 && flagMen > 0) {
    reuserName.push(<Field component={Radio} name="docindex" label="面接医" checkedValue={`${checkValue[0]}`} key={0} />);
  }
  if (data && data.hanflg === 1 && flagJud > 0) {
    reuserName.push(<Field component={Radio} name="docindex" label="判定医" checkedValue={`${checkValue[1]}`} key={1} />);
  }
  if (data && data.kanflg === 1 && flagKan > 0) {
    reuserName.push(<Field component={Radio} name="docindex" label="看護師" checkedValue={`${checkValue[2]}`} key={2} />);
  }
  if (data && data.eiflg === 1 && flagEif > 0) {
    reuserName.push(<Field component={Radio} name="docindex" label="栄養士" checkedValue={`${checkValue[3]}`} key={3} />);
  }
  if (data && data.shinflg === 1 && flagShi > 0) {
    reuserName.push(<Field component={Radio} name="docindex" label="診察医" checkedValue={`${checkValue[4]}`} key={4} />);
  }
  if (data && data.naiflg === 1 && flagNai > 0) {
    reuserName.push(<Field component={Radio} name="docindex" label="内視鏡医" checkedValue={`${checkValue[5]}`} key={5} />);
  }
  return reuserName;
};

class EntryAutherGuide extends React.Component {
  // 登録
  handleSubmit(values) {
    const { onSubmit, match, hainsUserData, checkValue } = this.props;
    onSubmit(values, match.params, hainsUserData, checkValue);
  }

  render() {
    const { handleSubmit, message, onClose, hainsUserData, flagMen, flagJud, flagKan, flagEif, flagShi, flagNai, flagCheck, checkValue } = this.props;
    return (
      <GuideBase {...this.props} title="担当者登録" usePagination={false}>
        <div style={{ height: 300 }}>
          <form>
            <div>
              <Button onClick={onClose} value="キャンセル" />
              { /* TODO if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then */ }
              {(flagCheck > 0) && <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="保存" />}
            </div>
            <MessageBanner messages={message} />
            <div style={{ marginTop: '10px' }}>
              現在の担当者は、{hainsUserData.username} さんです。
            </div>
            {(flagCheck === 0) ?
              <div>
                {hainsUserData.username}さんに対応する判定医ＩＤが登録されていません。管理者に連絡してください。
              </div>
            :
              <div>
                <WrapperWrap>
                  <WrapperWrap>{hainsUserData.username}さんを&nbsp;&nbsp;</WrapperWrap>
                  <Wrapper><JudDocDetail data={hainsUserData} flagMen={flagMen} flagJud={flagJud} flagKan={flagKan} flagEif={flagEif} flagShi={flagShi} flagNai={flagNai} checkValue={checkValue} />
                  </Wrapper>
                  <WrapperWrap>&nbsp;&nbsp;として登録します。よろしいですか？</WrapperWrap>
                </WrapperWrap>
              </div>}
          </form>
        </div>
      </GuideBase>
    );
  }
}

const EntryAutherGuideForm = reduxForm({
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(EntryAutherGuide);

EntryAutherGuide.propTypes = {
  match: PropTypes.shape().isRequired,
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  hainsUserData: PropTypes.shape(),
  flagMen: PropTypes.number,
  flagJud: PropTypes.number,
  flagKan: PropTypes.number,
  flagEif: PropTypes.number,
  flagShi: PropTypes.number,
  flagNai: PropTypes.number,
  flagCheck: PropTypes.number,
  checkValue: PropTypes.arrayOf(PropTypes.number),
};

EntryAutherGuide.defaultProps = {
  hainsUserData: {},
  flagMen: 0,
  flagJud: 0,
  flagKan: 0,
  flagEif: 0,
  flagShi: 0,
  flagNai: 0,
  flagCheck: 0,
  checkValue: [0, 0, 0, 0, 0, 0],
};

const mapStateToProps = (state) => ({
  message: state.app.result.result.entryAutherList.message,
  // 可視状態
  visible: state.app.result.result.entryAutherList.visible,
  hainsUserData: state.app.result.result.entryAutherList.hainsUserData,
  flagMen: state.app.result.result.entryAutherList.flagMen,
  flagJud: state.app.result.result.entryAutherList.flagJud,
  flagKan: state.app.result.result.entryAutherList.flagKan,
  flagEif: state.app.result.result.entryAutherList.flagEif,
  flagShi: state.app.result.result.entryAutherList.flagShi,
  flagNai: state.app.result.result.entryAutherList.flagNai,
  flagCheck: state.app.result.result.entryAutherList.flagCheck,
  checkValue: state.app.result.result.entryAutherList.checkValue,
  initialValues: {
    docindex: state.app.result.result.entryAutherList.docindex,
  },
});

const mapDispatchToProps = (dispatch) => ({
  onSubmit: (data, params, hainsData, checkValue) => {
    const { rsvno } = params;
    const { docindex } = data;
    const indexpara = Number.parseInt(docindex, 10);
    const checkSaveValue = [];
    const itemparamsVlue = [];
    let j = 0;
    if (checkValue[0] !== 0) {
      checkSaveValue.push(checkValue[0]);
      itemparamsVlue.push('30950');
    }
    if (checkValue[1] !== 0) {
      checkSaveValue.push(checkValue[1]);
      itemparamsVlue.push('30910');
    }
    if (checkValue[2] !== 0) {
      checkSaveValue.push(checkValue[2]);
      itemparamsVlue.push('30960');
    }
    if (checkValue[3] !== 0) {
      checkSaveValue.push(checkValue[3]);
      itemparamsVlue.push('30970');
    }
    if (checkValue[4] !== 0) {
      checkSaveValue.push(checkValue[4]);
      itemparamsVlue.push('39230');
    }
    if (checkValue[5] !== 0) {
      checkSaveValue.push(checkValue[5]);
      itemparamsVlue.push('23320');
    }

    for (let i = 0; i < checkSaveValue.length; i += 1) {
      if (checkSaveValue[i] === indexpara) {
        j += 1;
      }
    }
    if (j === 0) {
      dispatch(getEntryAutherSelectRadio());
      return;
    }
    const results = [];
    results.push({ itemcd: itemparamsVlue[indexpara - 1], suffix: '00', result: hainsData.sentencecd });
    dispatch(registerEntryAutherRequest({ ...data, results, rsvno }));
  },

  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeEntryAutherGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(EntryAutherGuideForm);
