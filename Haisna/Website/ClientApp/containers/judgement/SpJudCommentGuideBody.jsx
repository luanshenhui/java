import React from 'react';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';
import { connect } from 'react-redux';
import Button from '../../components/control/Button';
import SectionBar from '../../components/SectionBar';
import { changeSpecialJudCmtRequest } from '../../modules/judgement/specialInterviewModule';

class SpJudCommentGuideBody extends React.Component {
  constructor(props) {
    super(props);
    this.handleActionClick = this.handleActionClick.bind(this);
  }
  // 追加, 挿入, 修正, 削除時の処理
  handleActionClick({ values, mode }) {
    const { onAction } = this.props;
    onAction(values, mode);
  }

  render() {
    const { handleSubmit, judcmtdata } = this.props;
    return (
      <div>
        <SectionBar title="階層化コメント" />
        <div>
          <div>
            <Button onClick={handleSubmit((values) => this.handleActionClick({ values, mode: 'A' }))} value="追加" />
            <Button onClick={handleSubmit((values) => this.handleActionClick({ values, mode: 'I' }))} value="挿入" />
            <Button onClick={handleSubmit((values) => this.handleActionClick({ values, mode: 'C' }))} value="修正" />
            <Button onClick={handleSubmit((values) => this.handleActionClick({ values, mode: 'D' }))} value="削除" />
          </div>
          <Field name="selectSpecialJudlist" component="select" style={{ width: '600px' }} size="7" >
            {judcmtdata && judcmtdata.map((rec, index) => (
              <option key={index.toString()} value={rec.judcmtseq}>{rec.judcmtstc}</option>
            ))}
          </Field>
        </div>
      </div>

    );
  }
}

SpJudCommentGuideBody.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  onAction: PropTypes.func.isRequired,
  judcmtdata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

const mapStateToProps = (state) => ({
  judcmtdata: state.app.judgement.specialInterview.spJudCommentGuide.judcmtdata,
});

const mapDispatchToProps = (dispatch) => ({
  onAction: (data, mode) => {
    const { selectSpecialJudlist } = data;
    // TODO 追加, 挿入, 修正押下の時、特定健診コメント選択画面open
    // 追加, 挿入, 修正, 削除処理を呼び出す
    dispatch(changeSpecialJudCmtRequest({ selectSpecialJudlist, mode }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(SpJudCommentGuideBody);
