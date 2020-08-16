import ReactOnRails from 'react-on-rails';
import React from 'react';
import { ResponsivePie } from '@nivo/pie'

class SectionPieChart extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const section_data = this.props.data;
    let data = [
      {
        "id": `Correct [${section_data.correct}]`,
        "label": "correct",
        "value": section_data.correct,
        "color": "rgb(2, 160, 0)"
      },
      {
        "id": `Wrong [${section_data.incorrect}]`,
        "label": "wrong",
        "value": section_data.incorrect,
        "color": "rgb(195, 0, 0)"
      },
      {
        "id": `Not Sovled [${section_data.not_answered}]`,
        "label": "not_solved",
        "value": section_data.not_answered,
        "color": "gray"
      }
    ];

    if (section_data.input_questions_present) {
      let input_data = [
        {
          "id": `Input Correct [${section_data.correct_input_questions}]`,
          "label": "correct",
          "value": section_data.correct_input_questions,
          "color": "rgb(2, 160, 0, 0.5)"
        },
        {
          "id": `Input Wrong [${section_data.incorrect_input_questions}]`,
          "label": "wrong",
          "value": section_data.incorrect_input_questions,
          "color": "rgb(195, 0, 0, 0.5)"
        },
      ];
      data = data.concat(input_data);
    }

    return(
      <div>
        <table className="table table-sm table-bordered">
          <tbody>
            <tr>
              <td colSpan="3">
                <div className="text-right">
                  <button type="button" className="btn btn-outline-info btn-sm">{ section_data.section_name && section_data.section_name.toUpperCase() }</button>
                </div>
                <div class='graph-container' style={{height: 160}}>
                  <ResponsivePie
                    data={data}
                    margin={{ top: 0, right: 0, bottom: 20, left: 0 }}
                    innerRadius={0.5}
                    padAngle={1.9}
                    cornerRadius={3}
                    colors={d => d.color}
                    borderWidth={0}
                    borderColor={{ from: 'color', modifiers: [ [ 'darker', 0.2 ] ] }}
                    radialLabelsSkipAngle={10}
                    radialLabelsTextXOffset={6}
                    radialLabelsTextColor="#333333"
                    radialLabelsLinkOffset={0}
                    radialLabelsLinkDiagonalLength={16}
                    radialLabelsLinkHorizontalLength={24}
                    radialLabelsLinkStrokeWidth={1}
                    radialLabelsLinkColor={{ from: 'color' }}
                    slicesLabelsSkipAngle={10}
                    slicesLabelsTextColor="#333333"
                    animate={true}
                    motionStiffness={90}
                    motionDamping={25}
                    enableRadialLabels={false}
                    defs={[
                        {
                            id: 'dots',
                            type: 'patternDots',
                            background: 'inherit',
                            color: 'rgba(255, 255, 255, 0.3)',
                            size: 4,
                            padding: 1,
                            stagger: true
                        },
                        {
                            id: 'lines',
                            type: 'patternLines',
                            background: 'inherit',
                            color: 'rgba(255, 255, 255, 0.3)',
                            rotation: -45,
                            lineWidth: 6,
                            spacing: 10
                        }
                    ]}
                    fill={[
                      {
                          match: {
                              id: 'correct'
                          },
                          id: 'dots'
                      }
                    ]}
                    legends={[
                        {
                            anchor: 'bottom',
                            direction: 'row',
                            translateY: 20,
                            itemWidth: 100,
                            itemHeight: 18,
                            itemTextColor: '#000',
                            symbolSize: 18,
                            symbolShape: 'circle'
                        }
                    ]}
                  />
                </div>
              </td>
            </tr>
            <tr>
              <td>Score: </td>
              <td>
                <h5>{`${section_data.score} / ${(section_data.section_out_of_marks)}`}</h5>
              </td>
              <td>
                Topper: <span className="badge badge-warning">{section_data.topper_score}</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    )
  }
}

export default SectionPieChart;