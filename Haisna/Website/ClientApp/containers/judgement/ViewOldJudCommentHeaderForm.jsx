import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, reduxForm, getFormValues } from 'redux-form';
import { withRouter } from 'react-router-dom';
import MessageBanner from '../../components/MessageBanner';
import { getCsGrpDataRequest, getViewOldConsultHistoryRequest, closeViewOldJudCommentGuide } from '../../modules/judgement/interviewModule';
import Button from '../../components/control/Button';
import SectionBar from '../../components/SectionBar';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import DropDown from '../../components/control/dropdown/DropDown';

const formName = 'ViewOldJudCommentHeader';

// 前回値DropDown
const lastCsGrpItems = ({ csGrpData }) => {
  let res = [];
  if (csGrpData && csGrpData.length > 0) {
    res = csGrpData.map((rec) => ({ value: rec.csgrpcd, name: rec.csgrpname }));
  }
  res.push({ value: 0, name: 'すべてのコース' });
  res.push({ value: 1, name: '同一コースのみ' });
  return res;
};

class ViewOldJudCommentHeader extends React.Component {
  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // 表示ボタンクリック時の処理
  handleTotalJudCmtClick(values) {
    const { onSearch, match, consultHistoryData } = this.props;
    onSearch({ values, params: match.params, consultHistoryData });
  }

  render() {
    const { csGrpData, message, handleSubmit } = this.props;

    return (
      <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
        <div>
          <SectionBar title="過去総合コメント一覧" />
          <MessageBanner messages={message} />
          <FieldGroup>
            <FieldSet>
              <FieldItem>前回値：</FieldItem>
              <Field name="csgrpcd" component={DropDown} items={lastCsGrpItems({ csGrpData })} />
              <Label>を</Label>
              <div>
                <Button onClick={handleSubmit((values) => this.handleTotalJudCmtClick(values))} value="表示" />
              </div>
            </FieldSet>
          </FieldGroup>
        </div>
      </form>
    );
  }
}

const ViewOldJudCommentHeaderForm = reduxForm({
  form: formName,
})(ViewOldJudCommentHeader);

ViewOldJudCommentHeader.propTypes = {
  match: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  csGrpData: PropTypes.arrayOf(PropTypes.shape()),
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onSearch: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  consultHistoryData: PropTypes.arrayOf(PropTypes.shape()),
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    message: state.app.judgement.interview.viewOldJudCommentList.message,
    csGrpData: state.app.judgement.interview.viewOldJudCommentList.csGrpData,
    consultHistoryData: state.app.judgement.interview.viewOldJudCommentList.consultHistoryData,
  };
};

ViewOldJudCommentHeader.defaultProps = {
  csGrpData: [],
  consultHistoryData: [],
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    const { rsvno, cscd } = params;
    if (rsvno === undefined) {
      return;
    }
    dispatch(getCsGrpDataRequest(params));
    // 総合コメント取得
    dispatch(getViewOldConsultHistoryRequest({ ...params, cscd }));
  },
  onSearch: ({ values, params, consultHistoryData }) => {
    const cscd = (consultHistoryData === undefined || consultHistoryData.length === 0) ? params.cscd : consultHistoryData[0].cscd;
    const { csgrpcd } = values;
    // 総合コメント取得
    dispatch(getViewOldConsultHistoryRequest({ ...params, cscd, csgrpcd }));
  },
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeViewOldJudCommentGuide());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(ViewOldJudCommentHeaderForm));

